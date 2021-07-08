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
    var location: Location
    var picture: Picture
    var uid: UUID = UUID()
    var id: Int = 0
    
    // Coding keys for encoding and decoding
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case phone
        case picture
        case location
    }
    
    // MARK: - Initializers
    init(name: Name, email: String, phone: String, picture: Picture, location: Location) {
        self.name = name
        self.email = email
        self.phone = phone
        self.picture = picture
        self.location = location
    }
    
    // MARK: - Codable
    required init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode the easy stuff
        let email = try container.decode(String.self, forKey: .email)
        let phone = try container.decode(String.self, forKey: .phone)
        let name = try container.decode(Name.self, forKey: .name)
        let picture = try container.decode(Picture.self, forKey: .picture)
        let location = try container.decode(Location.self, forKey: .location)
        
        // Set all the properties
        self.name = name
        self.email = email
        self.picture = picture
        self.phone = phone
        self.location = location
    }
    func capitalizeFirstLetterOfNames() {
        self.name.title = name.title.capitalizingFirstLetter()
        self.name.first = name.first.capitalizingFirstLetter()
        self.name.last = name.last.capitalizingFirstLetter()
    }
    
}
