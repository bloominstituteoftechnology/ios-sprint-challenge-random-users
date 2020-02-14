//
//  UserResults.swift
//  Random Users
//
//  Created by Jorge Alvarez on 2/14/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

/*
 {
   "results": [
     {
       "name": {
         "title": "Miss",
         "first": "Olivia",
         "last": "Baker"
       },
       "email": "olivia.baker@example.com",
       "phone": "071-149-0105",
       "picture": {
         "large": "https://randomuser.me/api/portraits/women/24.jpg",
         "medium": "https://randomuser.me/api/portraits/med/women/24.jpg",
         "thumbnail": "https://randomuser.me/api/portraits/thumb/women/24.jpg"
       }
     }
   ],
   "info": {
     "seed": "8acde85f4b5f66f2",
     "results": 1,
     "page": 1,
     "version": "1.3"
   }
 }
 */
// Wrong Way sort of
struct UserResults: Decodable {
    let results: [User]
}

struct User: Decodable {
    var name: Name
    var email: String
    var phone: String
    var picture: Picture

}

struct Name: Decodable {
    let first: String
    let last: String
}

struct Picture: Decodable {
    var thumbnail: URL
    var large: URL
}

//struct UserResults: Codable {
//    let results: [String]
//
//    enum UserResultsKeys: String, CodingKey {
//        case results
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: UserResultsKeys.self)
//
//        let resultsContainer = try container.nestedUnkeyedContainer(forKey: UserResultsKeys.results)
//
//        var results: [String] = []
//
//
//    }
//}
