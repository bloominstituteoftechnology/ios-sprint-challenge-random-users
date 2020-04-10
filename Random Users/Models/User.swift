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
        //var resultsContainer = try container.nestedUnkeyedContainer(forKey: .results)
        
        results = try container.decode([Result].self, forKey: .results)
        //results = try resultsContainer.decode([Result].self)
    
    }
    
}

// MARK: - Result
struct Result: Codable {
    let name: Name
    let email, phone: String
    let picture: Picture
    var id: UUID?
    
    enum ResultKeys: String, CodingKey {
        case email
        case phone
        case name
        case picture
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ResultKeys.self)
        email = try container.decode(String.self, forKey: .email)
        phone = try container.decode(String.self, forKey: .phone)
        
        name = try container.decode(Name.self, forKey: .name)
        picture = try container.decode(Picture.self, forKey: .picture)
        id = UUID()
    }
    
    
}

struct Name: Codable {
    let title, first, last: String
    
    enum NameKeys: String, CodingKey {
        case title
        case first
        case last
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: NameKeys.self)
        title = try container.decode(String.self, forKey: .title)
        first = try container.decode(String.self, forKey: .first)
        last = try container.decode(String.self, forKey: .last)
    }
    
    
}

struct Picture: Codable {
    let large, medium, thumbnail: URL
    
    enum PictureKeys: String, CodingKey {
        case large
        case medium
        case thumbnail
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PictureKeys.self)
        
        large = try container.decode(URL.self, forKey: .large)
        medium = try container.decode(URL.self, forKey: .medium)
        thumbnail = try container.decode(URL.self, forKey: .thumbnail)
    }
    
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
