//
//  Users.swift
//  Random Users
//
//  Created by John Pitts on 6/21/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class Users: Decodable {
    
    enum Keys: String, CodingKey {
        case users
    }
    
    let users: [User]
    
    // Decodes data into users array, but am I double-decoding here?  Perhaps a User from below is already decoded, so I'm really just supposed to append User to users array here or in the basic init() above?
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        let users = try container.decode([User].self, forKey: .users)
        
//        var users: [User] = []
//        if container.contains(.users) {
//
//            var usersContainer = try container.nestedUnkeyedContainer(forKey: .users)
//            while !usersContainer.isAtEnd {
//                let user = try usersContainer.decode(User.self)
//                users.append(user)
//            }  // end while
//        } // end if
        self.users = users
    } // end req'd init
} // end Users class

class User: Decodable {
    
    enum UserKeys: String, CodingKey {
        case name
        case phone
        case email
        case picture
        
        enum NameKeys: String, CodingKey {
            case title
            case first
            case last
        }
        
        enum PictureKeys: String, CodingKey {
            case medium
        }
    } // end enums
    
    // NAV: Property Type Declarations
    // for name we will simply concatenate title + first + last names into one name
    let name: String
    let phone: String
    let email: String
    let image: URL


    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: UserKeys.self)
        
        let phone =  try container.decode(String.self, forKey: .phone)
        let email =  try container.decode(String.self, forKey: .email)
        
        let nameContainer = try container.nestedContainer(keyedBy: UserKeys.NameKeys.self, forKey: .name)
        let title = try nameContainer.decode(String.self, forKey: .title)
        let first = try nameContainer.decode(String.self, forKey: .first)
        let last = try nameContainer.decode(String.self, forKey: .last)
        //let name = "\(title). \(first) \(last)"
        
        let pictureContainer = try container.nestedContainer(keyedBy: UserKeys.PictureKeys.self, forKey: .picture)
        let medium = try pictureContainer.decode(URL.self, forKey: .medium)
        

        self.name = "\(title). \(first) \(last)"
        self.email = email
        self.phone = phone
        self.image = medium
    }
    
}

// wrote this bc i THOUGHT i saw an "add" button on the gif, but won't implement until the end if I need it
//        func encode(to encoder: Encoder) throws {
//
//            var container = encoder.container(keyedBy: UserKeys.self)
//
//            var nameContainer = container.nestedContainer(keyedBy: CodingKeys.NameCodingKeys.self, forKey: .name)
//            try nameContainer.encode(phone, forKey: .name)
//
//            try container.encode(identifier, forKey: .phone)
//
//            var emailContainer = container.nestedContainer(keyedBy: CodingKeys.DurationCodingKeys.self, forKey: .email)
//            try emailContainer.encode(duration, forKey: .email)
//        }
