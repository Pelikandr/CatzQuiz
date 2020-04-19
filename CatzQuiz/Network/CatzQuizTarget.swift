//
//  CatzQuizTarget.swift
//  CatzQuiz
//
//  Created by pelikandr on 19.04.2020.
//  Copyright © 2020 pelikandr. All rights reserved.
//

import Foundation

enum CatzQuizTarget {
    case getAllBreeds
    case getImage(_ breedID: String)
}

extension CatzQuizTarget: RequestTarget {
    var URL: String {
        NetworkConfiguration.baseURL
    }

    var route: Route {
        switch self {
        case .getAllBreeds:
            return .get("/breeds")
        case .getImage(_):
            return .get("/images/search")
        }
    }

    var params: [String : Any]? {
        switch self {
        case .getAllBreeds:
            return nil
        case .getImage(let breedID):
            return ["breed_id": breedID]
        }
    }
}


