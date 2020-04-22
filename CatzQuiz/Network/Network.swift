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
    let description: String
    var sampleImageURL: String?
    
    init(id: String, name: String, description: String, sampleImageURL: String? = nil) {
        self.id = id
        self.name = name
        self.description = description
        self.sampleImageURL = sampleImageURL
    }
}

struct CatImage: Decodable {
    let id: String
    let url: String
    let width: Int
    let height: Int
}

class Network: NSObject, URLSessionDelegate {
    
    static var shared: Network = Network()
    
    private lazy var dataSession: URLSession = { return URLSession(configuration: .default) }()
    private lazy var downloadsSession: URLSession = {
        return URLSession(configuration: URLSessionConfiguration.default)
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
            
            let fileName = url.lastPathComponent
            let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .allDomainsMask).first
            guard let localUrl = cacheDirectory?.appendingPathComponent(fileName) else {
                completion(NetworkError.emptyResponse, nil)
                return
            }
                        
            guard !FileManager.default.fileExists(atPath: localUrl.path) else {
                completion(nil, localUrl)
                return
            }
            
            let downloadTask = self?.downloadsSession.downloadTask(with: url) { (location: URL?, _: URLResponse?, error: Error?) in
                
                guard let location = location else {
                    completion(NetworkError.emptyResponse, nil)
                    return
                }
                
                guard !FileManager.default.fileExists(atPath: localUrl.path) else {
                    completion(nil, localUrl)
                    return
                }
                
                do {
                    try FileManager.default.copyItem(at: location, to: localUrl)
                    try FileManager.default.removeItem(at: location)
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
