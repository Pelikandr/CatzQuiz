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
    var id: String
}

class Network {
    
    let apiKey = "fbc8cc25-8abb-4ab6-9dd0-6afcde5fe49c"
    
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
    
}
