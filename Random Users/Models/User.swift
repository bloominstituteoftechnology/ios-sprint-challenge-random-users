//
//  User.swift
//  Random Users
//
//  Created by Wyatt Harrell on 4/10/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation




// MARK: - Users
struct Users: Codable {
    var results: [Result]
    
    enum UserKeys: String, CodingKey {
        case results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UserKeys.self)
        var resultsContainer = try container.nestedUnkeyedContainer(forKey: .results)
        
        results = try container.decode([Result].self, forKey: .results)
        //results = try resultsContainer.decode([Result].self)
    
    }
    
}

// MARK: - Result
struct Result: Codable {
    //let name: Name
    let email, phone: String
    //let picture: Picture
    
    enum ResultKeys: String, CodingKey {
        case email
        case phone
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ResultKeys.self)
        email = try container.decode(String.self, forKey: .email)
        phone = try container.decode(String.self, forKey: .phone)
    }
    
    
}

struct Name: Codable {
    let title, first, last: String
}

struct Picture: Codable {
    let large, medium, thumbnail: String
}





/*
 
 {
   "results": [
     {
       "name": {
         "title": "Mademoiselle",
         "first": "Bettina",
         "last": "Joly"
       },
       "email": "bettina.joly@example.com",
       "phone": "078 901 27 91",
       "picture": {
         "large": "https://randomuser.me/api/portraits/women/5.jpg",
         "medium": "https://randomuser.me/api/portraits/med/women/5.jpg",
         "thumbnail": "https://randomuser.me/api/portraits/thumb/women/5.jpg"
       }
     },
     {
       "name": {
         "title": "Mrs",
         "first": "Caroline",
         "last": "Lambert"
       },
       "email": "caroline.lambert@example.com",
       "phone": "031-469-1485",
       "picture": {
         "large": "https://randomuser.me/api/portraits/women/59.jpg",
         "medium": "https://randomuser.me/api/portraits/med/women/59.jpg",
         "thumbnail": "https://randomuser.me/api/portraits/thumb/women/59.jpg"
       }
     }
   ],
   "info": {
     "seed": "b48ec4170f518225",
     "results": 2,
     "page": 1,
     "version": "1.3"
   }
 }
 
*/
