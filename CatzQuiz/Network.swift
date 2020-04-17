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
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                    print("======[Server error]======")
                    print(response as Any)
                    print("==========================")
                    return
            }
            guard let mime = response?.mimeType, mime == "application/json" else {
                print("======[Wrong MIME type]======")
                return
            }
            do {
                let breeds = try JSONDecoder().decode(Array<Breed>.self, from: data!)
//                let json = try JSONSerialization.jsonObject(with: data!, options: [])
//                print("======[JSON]======")
//                print(json)
//                print("==================")
//                print(breeds)
//                print("==================")
                completion(breeds)
            } catch {
                print("======[JSON error: \(error.localizedDescription)]======")
            }
        })
        task.resume()
    }
    
    //        var request = URLRequest(url: url)
    //        request.httpMethod = "GET"
    //        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
            
    //        let json = [
    //            "id": "abys"
    //        ]
    //        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])
    
}
