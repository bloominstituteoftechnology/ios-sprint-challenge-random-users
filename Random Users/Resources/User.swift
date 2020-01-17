//
//  User.swift
//  Random Users
//
//  Created by Thomas Sabino-Benowitz on 12/7/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct userlist: Codable {
    
    enum resultsKeys: String, CodingKey {
    case results
        
        enum userKeys: String, CodingKey {
            case name
            case email
            case phone
            case picture
        
            enum nameKeys: String, CodingKey {
                case first
                case last
            }
            enum pictureKeys: String, CodingKey {
                case large
                case medium
                case thumbnail
            }
            
        }
    }
    
    let results: [User]
    
    struct User: Codable {
    var name: Name
    var email: String
    var phone: String
    var picture: Picture
    
}
    
    struct Name: Codable {
        var first: String
        var last: String
    }

struct Picture: Codable {
    var large: URL
    var medium: URL
    var thumbnail: URL
}

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: resultsKeys.self)
        
        results = try container.decode
    }
    
}

//"results": [
//  {
//    "name": {
//      "title": "Mr",
//      "first": "Anton",
//      "last": "Rasmussen"
//    },
//    "email": "anton.rasmussen@example.com",
//    "phone": "53725325",
//    "picture": {
//      "large": "https://randomuser.me/api/portraits/men/52.jpg",
//      "medium": "https://randomuser.me/api/portraits/med/men/52.jpg",
//      "thumbnail": "https://randomuser.me/api/portraits/thumb/men/52.jpg"
//    }
