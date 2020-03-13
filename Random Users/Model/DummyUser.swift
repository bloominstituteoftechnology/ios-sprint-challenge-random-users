//
//  DummyUser.swift
//  Random Users
//
//  Created by Joseph Rogers on 3/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

enum CodingKeys: String, CodingKey {
    case name
    case phone
    case email
    case picture
    
      enum NameKeys: String, CodingKey {
          case first, last
      }
    enum ImageKeys: String, CodingKey {
        case large, thumbnail
    }
  
}

enum UserKeys: String, CodingKey  {
    case results
}

struct User: Equatable, Decodable {
    // MARK: Properties
    let name: String
    let phone: String
    let email: String
    let thumbnailImage: URL
    let largeImage: URL
    
    
    init(name: String, phone:String, email:String, thumbnailImage: URL, largeImage: URL) {
        self.name = name
        self.phone = phone
        self.email = email
        self.thumbnailImage = thumbnailImage
        self.largeImage = largeImage
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let nameContainer = try container.nestedContainer(keyedBy: CodingKeys.NameKeys.self, forKey: .name)
        let firstName = try nameContainer.decode(String.self, forKey: .first)
        let lastName = try nameContainer.decode(String.self, forKey: .last)
        self.name = "\(firstName) \(lastName)"
        
        self.phone = try container.decode(String.self, forKey: .phone)
        self.email = try container.decode(String.self, forKey: .email)
        
        let thumbnailImageContainer = try container.nestedContainer(keyedBy: CodingKeys.ImageKeys.self, forKey: .picture)
        self.thumbnailImage = try thumbnailImageContainer.decode(URL.self, forKey: .thumbnail)
        
        let ImageContainer = try container.nestedContainer(keyedBy: CodingKeys.ImageKeys.self, forKey: .picture)
        self .largeImage = try ImageContainer.decode(URL.self, forKey: .large)
    }
}

struct Users: Decodable {

    let results: [User]
    

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UserKeys.self)
        self.results = try container.decode([User].self, forKey: .results)
    }
}
