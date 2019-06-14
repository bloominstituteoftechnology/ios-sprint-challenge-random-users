//
//  User.swift
//  Random Users
//
//  Created by Michael Flowers on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct User: Codable {
    var name: String
    var email: String
    var phone: String
    var picture: Picture
    
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case phone
        case picture
        
        //because name's value is a dictionary
        enum NameKeys: String, CodingKey {
            case first
            case last
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let nameKeyContainer = try container.nestedContainer(keyedBy: CodingKeys.NameKeys.self, forKey: .name)
        let firstName = try nameKeyContainer.decode(String.self, forKey: .first)
        let lastName = try nameKeyContainer.decode(String.self, forKey: .last)
        name = firstName + lastName
        
        picture = try container.decode(Picture.self, forKey: .picture)
//        let pictureKeyContainer = try container.nestedContainer(keyedBy: CodingKeys.PictureKeys.self, forKey: .picture)
//        picture = try pictureKeyContainer.decode(Picture.self, forKey: .large)
//        picture.large = try pictureKeyContainer.decode(String.self, forKey: .large)
//        picture.thumbnail = try pictureKeyContainer.decode(String.self, forKey: .thumbnail)
        email = try container.decode(String.self, forKey: .email)
        phone = try container.decode(String.self, forKey: .phone)
    }
    
    func encode(with encoder:Encoder) throws {
        
    }
}
