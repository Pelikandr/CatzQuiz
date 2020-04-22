//
//  UserDefaultsPropertyWrapper.swift
//  CatzQuiz
//
//  Created by pelikandr on 20.04.2020.
//  Copyright © 2020 pelikandr. All rights reserved.
//

import Foundation

@propertyWrapper struct UserDefault<T: Codable> {
    let key: String
    let defaultValue: T
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            if let data = UserDefaults.standard.object(forKey: key) as? Data {
                return (try? PropertyListDecoder().decode(T.self, from: data)) ?? defaultValue
            }
            return defaultValue
        }
        set {
            if let data = try? PropertyListEncoder().encode(newValue) {
                UserDefaults.standard.set(data, forKey: key)
            }
        }
    }
}
