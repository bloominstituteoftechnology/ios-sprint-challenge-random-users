//
//  RandomUser.swift
//  Random Users
//
//  Created by Benjamin Hakes on 1/25/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation


class RandomUser: Codable, CustomStringConvertible {
    
    // MARK: - Properties
    // Provide a custom description to make the print statements a little prettier.
    var description: String {
        return "\(name)"
    }
    
    var name: Name
    var email: String
    var phone: String
    var picture: Picture
    
    // Coding keys for encoding and decoding
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case phone
        case picture

    }
    
    // MARK: - Initializers
    init(name: Name, email: String, phone: String, picture: Picture) {
        self.name = name
        self.email = email
        self.phone = phone
        self.picture = picture
    }
    
    // MARK: - Codable
    required init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode the easy stuff
        let email = try container.decode(String.self, forKey: .email)
        let phone = try container.decode(String.self, forKey: .phone)
        let name = try container.decode(Name.self, forKey: .name)
        let picture = try container.decode(Picture.self, forKey: .picture)
        
        // Set all the properties
        self.name = name
        self.email = email
        self.picture = picture
        self.phone = phone
    }
    
    // not sure if we'll need this
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        // Encode the easy stuff
        
        try container.encode(name, forKey: .name)
        try container.encode(email, forKey: .email)
        try container.encode(picture, forKey: .picture)
        try container.encode(phone, forKey: .phone)
        
    }
}
