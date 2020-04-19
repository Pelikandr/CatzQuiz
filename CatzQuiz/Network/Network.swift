//
//  Network.swift
//  CatzQuiz
//
//  Created by pelikandr on 16/04/2020.
//  Copyright © 2020 pelikandr. All rights reserved.
//

import Foundation
import UIKit

public enum NetworkError: Error {
    case emptyResponse
    case invalidRequest
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .emptyResponse:
            return "Empty response"
        case .invalidRequest:
            return "Invalid request configuration"
        }
    }
}

struct Breed: Decodable {
    let id: String
    let name: String
}

struct CatImage: Decodable {
    let id: String
    let url: String
}

class Network: NSObject, URLSessionDelegate {

    static var shared: Network = Network()

    private lazy var dataSession: URLSession = { return URLSession(configuration: .default) }()
    private lazy var downloadsSession: URLSession = {
        return URLSession(configuration: URLSessionConfiguration.default)//background(withIdentifier: "CatzQuizDownloadSession"))
    }()

    deinit {
        self.dataSession.invalidateAndCancel()
    }

    func getAllBreeds(completion: @escaping (Error?, [Breed]?) -> Void) {
        request(CatzQuizTarget.getAllBreeds, completion: completion)
    }

    func getImage(with breedID: String, completion: @escaping (Error?, [CatImage]?) -> Void) {
        request(CatzQuizTarget.getImage(breedID), completion: completion)
    }
    
    func saveImage(from url: String, completion: @escaping (Error?, URL?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let url = URL(string: url) else {
                completion(NetworkError.invalidRequest, nil)
                return
            }
            debugPrint("DOWNLOAD: \(url.absoluteString)")

            let downloadTask = self?.downloadsSession.downloadTask(with: url) { (location: URL?, _: URLResponse?, error: Error?) in

                guard let location = location else {
                    completion(NetworkError.emptyResponse, nil)
                    return
                }

                let fileName = url.lastPathComponent
                guard let localUrl = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName) else {
                    completion(NetworkError.emptyResponse, nil)
                    return
                }

                do {
                    if !FileManager.default.fileExists(atPath: localUrl.absoluteString) {
                        try FileManager.default.copyItem(at: location, to: localUrl)
                    }
                    completion(nil, localUrl)
                }
                catch {
                    completion(error, nil)
                }
            }
            downloadTask?.resume()
        }
    }

    // MARK: - Private

    private func request<Output: Decodable>(_ target: RequestTarget, completion: @escaping (Error?, Output?) -> Void) {

        DispatchQueue.global(qos: .userInitiated).async {

            guard var urlComponents = URLComponents(string: "\(target.URL)\(target.route.path)") else {
                completion(NetworkError.invalidRequest, nil)
                return
            }
            urlComponents.queryItems = target.params?.map({ (arg) -> URLQueryItem in
                return URLQueryItem(name: arg.key, value: String(describing: arg.value))
            })

            guard let url = urlComponents.url else {
                completion(NetworkError.invalidRequest, nil)
                return
            }

            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = target.route.method
            urlRequest.setValue(NetworkConfiguration.apiKey, forHTTPHeaderField: "x-api-key")

            debugPrint("REQUEST: \(urlRequest)")

            let dataTask = self.dataSession.dataTask(with: urlRequest) { (data, response, error) in
               if let error = error {
                    completion(error, nil)
                }
                else if let data = data {
                    do {
                        let output = try JSONDecoder().decode(Output.self, from: data)
                        completion(nil, output)
                    }
                    catch {
                        completion(error, nil)
                    }
                }
            }

            dataTask.resume()
        }
    }
}