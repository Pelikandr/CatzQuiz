//
//  Network.swift
//  CatzQuiz
//
//  Created by pelikandr on 16/04/2020.
//  Copyright © 2020 pelikandr. All rights reserved.
//

import Foundation
import UIKit

struct Breed: Codable {
    var url: String
}

class Network {
    
    let apiKey = "223befc9-223e-4801-93cb-8df64d10f177"
    
    func getBreeds(completion: @escaping ([Breed]) ->() ) {
        let session = URLSession.shared
        let url = URL(string: "https://api.thecatapi.com/v1/breeds")!
        
        let task = session.dataTask(with: url, completionHandler: { data, response, error in
            if error != nil || data == nil {
                print(error?.localizedDescription as Any)
            } else {
                do {
                    let breeds = try JSONDecoder().decode(Array<Breed>.self, from: data!)
                    completion(breeds)
                } catch {
                    print("======[JSON error: \(error.localizedDescription)]======")
                }
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    print(response as Any)
                    return
            }
            guard let mime = response?.mimeType, mime == "application/json" else {
                print("======[Wrong MIME type]======")
                return
            }
        })
        task.resume()
    }
    
    func getImage(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func getImagesFullInfo(completion: @escaping ([Breed]) ->() ) {
        
        let session = URLSession.shared
        //            let url = URL(string: "https://api.thecatapi.com/v1/images/search")!
        let url = URL(string: "https://api.thecatapi.com/v1/images")!
        
        let parametersJson = [
            //                "id": "IOjBCPLXA"
            "api_key": apiKey
        ]
        let parameters = try! JSONSerialization.data(withJSONObject: parametersJson, options: [])
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("f6615889-749c-4ff9-95f3-62b753430598", forHTTPHeaderField: "x-api-key")
        //            request.httpBody = parameters
        
        let task = session.dataTask(with: url, completionHandler: { data, response, error in
            if error != nil || data == nil {
                print(error?.localizedDescription as Any)
            } else {
                do {
                    if let json = try? JSONSerialization.jsonObject(with: data!, options: []) {
                        print("JSON: \(json)")
                    }
                    let breeds = try JSONDecoder().decode(Array<Breed>.self, from: data!)
                    completion(breeds)
                } catch {
                    print("======[JSON error: \(error.localizedDescription)]======")
                }
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    print(response as Any)
                    return
            }
            guard let mime = response?.mimeType, mime == "application/json" else {
                print("======[Wrong MIME type]======")
                return
            }
        })
        task.resume()
    }
    
}
