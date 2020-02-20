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
 // name: title, first, last -- email -- phone -- picture: medium
 */

// MARK: - User
struct User: Codable {
    let results: [Result]
}

// MARK: - Result
struct Result: Codable {
    let name: Name
    let email: String
    let phone: String
    let picture: Picture
}

// MARK: - Name
struct Name: Codable {
    let title, first, last: String
}

// MARK: - Picture
struct Picture: Codable {
    let medium: String
}


// Right way
//struct UserResults: Decodable {
//    let results: [String]
//
//    enum UserResultsKeys: String, CodingKey {
//        case results
//
//    }
//
//    init(from decoder: Decoder) throws {
//
//        let container = try decoder.container(keyedBy: UserResultsKeys.self)
//        // keyed instead?
//        results = try container.decode([String].self, forKey: .results)
//
//    }
//}

// Wrong Way sort of
//struct UserResults: Decodable {
//    let results: [User]
//}
//
//struct User: Decodable {
//    var name: Name
//    var email: String
//    var phone: String
//    var picture: Picture
//
//}
//
//struct Name: Decodable {
//    let first: String
//    let last: String
//}
//
//struct Picture: Decodable {
//    var thumbnail: URL
//    var large: URL
//}

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

/*
 WRONG
 struct Person: Codable {
     let name: String
     let height: Int
     let hairColor: String
     
     let films: [URL]
     let vehicles: [URL]
     let starships: [URL]

     enum CodingKeys: String, CodingKey {
         case name
         case height
         case hairColor = "hair_color"
         case films
         case vehicles
         case starships
     }
 }
 */

/* RIGHT
 struct Person: Codable {
   let name: String
   let height: Int
   let hairColor: String
   
   let films: [URL] //[String]
   let vehicles: [URL] //[String]
   let starships: [URL] //[String]
   
   enum PersonKeys: String, CodingKey {
     case name
     case height
     case hairColor = "hair_color"
     case films
     case vehicles
     case starships
   }
   
   init(from decoder: Decoder) throws {
     let container = try decoder.container(keyedBy: PersonKeys.self)
    
     1
     name = try container.decode(String.self, forKey: .name)
     2
     hairColor = try container.decode(String.self, forKey: .hairColor)
     3
     let heightString = try container.decode(String.self, forKey: .height)
     height = Int(heightString) ?? 0
     4
     films = try container.decode([URL].self, forKey: .films)
     5
     vehicles = try container.decode([URL].self, forKey: .vehicles)
     6
     starships = try container.decode([URL].self, forKey: .starships)
   }
 }
 */
