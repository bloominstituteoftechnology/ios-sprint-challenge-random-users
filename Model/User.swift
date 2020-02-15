//
//  User.swift
//  Random Users
//
//  Created by Austin Potts on 2/14/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

// Regular parsing models. These will be changed to manual conformance once testing is success
struct UserResults: Decodable {
    let results: [User]
}


struct User: Decodable {
    var name: Name
    var email: String
    var phone: String
    var picture: Picture
    
    enum UserKeys: String, CodingKey {
        case name
        case email
        case phone
        case picture
    }
    
    init(from decoder: Decoder) throws {
        
        // Set up the container
        let container = try decoder.container(keyedBy: UserKeys.self)
        
        email = try container.decode(String.self, forKey: .email)
        
        phone = try container.decode(String.self, forKey: .phone)
        
     
        name = try container.decode(Name.self, forKey: .name)
        
        picture = try container.decode(Picture.self, forKey: .picture)
        
        
    }
    
    
    
}

struct Name: Decodable {
    let first: String
    let last: String
    
    
    enum NameKeys: String, CodingKey {
        case first
        case last
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: NameKeys.self)
        
        first = try container.decode(String.self, forKey: .first)
        
        last = try container.decode(String.self, forKey: .last)
        
    }
    
}

struct Picture: Decodable {
    var thumbnail: URL
    var large: URL
    
    enum PictureKeys: String, CodingKey {
        case thumbnail
        case large
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: PictureKeys.self)
        
        thumbnail = try container.decode(URL.self, forKey: .thumbnail)
        
        large = try container.decode(URL.self, forKey: .large)
        
    }
}



