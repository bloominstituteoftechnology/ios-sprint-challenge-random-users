//
//  Users.swift
//  Random Users
//
//  Created by Enayatullah Naseri on 1/24/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation




// trying to get in the file
// Mapping in the API
struct User: Equatable, Decodable {
    
    // enum
    //Main enum
    enum Keys: String, CodingKey {
        case name
        case phone
        case email
        case picture
        
        //Name enum
        enum NameKeys: String, CodingKey {
            case first, last
        }
        
        //Image enum
        enum ImageKeys: String, CodingKey {
            case large, thumbnail
        }
    }
    
    let name: String
    let phone: String
    let email: String
    let thumbnailImage: URL
    let largeImage: URL
    
    
    // initializer
    init(name: String, phone: String, email: String, thumbnailImage: URL, largeImage: URL) {
        self.name = name
        self.phone = phone
        self.email = email
        self.thumbnailImage = thumbnailImage
        self.largeImage = largeImage
    }
    
    // initializers containers
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        // let nameContainer = container.nestedContainer(keyedBy: Keys.Name, forKey:)
        let nameContainer = try container.nestedContainer(keyedBy: Keys.NameKeys.self, forKey: .name)
        let firstName = try nameContainer.decode(String.self, forKey: .first)
        let lastName = try nameContainer.decode(String.self, forKey: .last)
        let thumbImageContainer = try container.nestedContainer(keyedBy: Keys.ImageKeys.self, forKey: .picture)
        let largeImageContainer = try container.nestedContainer(keyedBy: Keys.ImageKeys.self, forKey: .picture)
        
        
        
        //
        //
        //
        
        
        
        
        self.phone = try container.decode(String.self, forKey: .phone)
        self.email = try container.decode(String.self, forKey: .email)
        self.name = "\(firstName.capitalized) \(lastName.capitalized)"
        self.thumbnailImage = try thumbImageContainer.decode(URL.self, forKey: .thumbnail)
        self.largeImage = try largeImageContainer.decode(URL.self, forKey: .large)
    }
}


//struct User: Codable {
//
//    enum Keys: String, CodingKey {
//        case name
//        case phone
//        case email
//        case picture

//        enum NameKeys: String, CodingKey {
//        }
//        enum ImageKeys: String, CodingKey {
//
//        }
//    }
//}



//struct Users: Codable {
//init(from decoder: Decoder) throws {
//    let container = try decoder.container(keyedBy: UserKeys.self)
//
//    self.results = try container.decode([User].self, forKey: .results)
//}
//}

struct Users: Decodable {
    let results: [User]
    
    enum UserKeys: String, CodingKey {
        case results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UserKeys.self)
        
        self.results = try container.decode([User].self, forKey: .results)
    }
}

//

