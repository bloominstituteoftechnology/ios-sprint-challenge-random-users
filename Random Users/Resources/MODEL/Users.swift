//
//  Users.swift
//  Random Users
//
//  Created by John Pitts on 6/21/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class Users: Codable {
    
    enum Keys: String, CodingKey {
        case users
    }
    
    var users: [User]
    
    init(users: [User]) {
        self.users = users
    }
    
    // Decodes data into users array
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        var users: [User] = []
        if container.contains(.users) {
            
            var usersContainer = try container.nestedUnkeyedContainer(forKey: .users)
            while !usersContainer.isAtEnd {
                let user = try usersContainer.decode(User.self)
                users.append(user)
            }  // end while
        } // end if
    } // end req'd init
} // end Users

class User: Codable {
    
    enum UserKeys: String, CodingKey {
        case name
        case phone
        case email
        
        enum NameKeys: String, CodingKey {
            case title
            case first
            case last
        }
    } // end enums
    
    
    // NAV: Property Type Declarations
    
    let title: String
    let first: String
    let last: String
    let phone: String
    let email: String
    // for name we will simply concatenate title + first + last names into one name
    let name: String
    
    init(title: String, first: String, last: String, phone: String, email: String) {
            self.phone = phone
            self.email = email
            self.name = "\(title). \(first) \(last)"
    }
    
        required init(from decoder: Decoder) throws {
            
            let container = try decoder.container(keyedBy: UserKeys.self)
    
            let name = try container.decode(String.self, forKey: .name)
            let nameContainer = try container.nestedContainer(keyedBy: UserKeys.NameKeys.self, forKey: .name)
            
            let phone = try nameContainer.decode(String.self, forKey: .phone)
            let phoneContainer = try container.nestedContainer(keyedBy: CodingKeys.DurationCodingKeys.self, forKey: .phone)
            
            let email = try durationContainer.decode(String.self, forKey: .email)
            
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
}

