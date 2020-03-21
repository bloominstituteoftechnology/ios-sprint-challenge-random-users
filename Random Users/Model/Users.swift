//
//  Users.swift
//  Random Users
//
//  Created by denis cedeno on 3/20/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//
/*
 {
   "results": [
     {
       "name": {
         "title": "Mr",
         "first": "Çetin",
         "last": "Koçoğlu"
       },
       "email": "cetin.kocoglu@example.com",
       "phone": "(753)-789-9831",
       "picture": {
         "large": "https://randomuser.me/api/portraits/men/28.jpg",
         "medium": "https://randomuser.me/api/portraits/med/men/28.jpg",
         "thumbnail": "https://randomuser.me/api/portraits/thumb/men/28.jpg"
       }
     },
     {
       "name": {
         "title": "Miss",
         "first": "Enni",
         "last": "Ylitalo"
       },
       "email": "enni.ylitalo@example.com",
       "phone": "02-852-828",
       "picture": {
         "large": "https://randomuser.me/api/portraits/women/6.jpg",
         "medium": "https://randomuser.me/api/portraits/med/women/6.jpg",
         "thumbnail": "https://randomuser.me/api/portraits/thumb/women/6.jpg"
       }
     }
   ],
   "info": {
     "seed": "e5942e1d320cd4b6",
     "results": 2,
     "page": 1,
     "version": "1.3"
   }
 }
 */

import Foundation

struct Results: Codable {
    let results: [User]
    
    enum resultsCodingKey: CodingKey {
        case results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: resultsCodingKey.self)
        self.results = try container.decode([User].self, forKey: .results)
    }
}

struct User: Codable {
    let name: String
    let email: String
    let phone: String
    let pictureThumbnail: URL
    let pictureMedium: URL
    
    enum UserCodingKeys: String, CodingKey {
        case name
        enum NameCodingKey: String, CodingKey {
            case title
            case first
            case last
        }
        case email
        case phone
        case picture
        enum PictureCodingKey: String, CodingKey {
            case thumbnail
            case medium
        }
    }
    
    init(from decoder: Decoder) throws {
        let contianer = try decoder.container(keyedBy: UserCodingKeys.self)
        let nameConatiner = try contianer.nestedContainer(keyedBy: UserCodingKeys.NameCodingKey.self, forKey: .name)
        let title = try nameConatiner.decode(String.self, forKey: .title)
        let first = try nameConatiner.decode(String.self, forKey: .first)
        let last = try nameConatiner.decode(String.self, forKey: .last)
        self.name = "\(title) \(first) \(last)"
        self.email = try contianer.decode(String.self, forKey: .email)
        self.phone = try contianer.decode(String.self, forKey: .phone)
        let pictureContainer = try contianer.nestedContainer(keyedBy: UserCodingKeys.PictureCodingKey.self, forKey: .picture)
        self.pictureThumbnail = try pictureContainer.decode(URL.self, forKey: .thumbnail)
        self.pictureMedium = try pictureContainer.decode(URL.self, forKey: .medium)
        
    }
    
}
