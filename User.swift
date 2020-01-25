//
//  User.swift
//  Random Users
//
//  Created by Lambda_School_Loaner_201 on 1/25/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct Results: Decodable {
    let results: [User]
}

struct User: Decodable {
    let email: String
    let phone: String
    let name: String
    let picture: [String]
    
    enum CodingKeys: String, CodingKey {
        case email
        case phone
        case name
        case picture
        
        enum NameCodingKeys: String, CodingKey {
            case title
            case first
            case last
        }
        
        enum PictureCodingKeys: String, CodingKey {
            case large
            case medium
            case thumbnail
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        email = try container.decode(String.self, forKey: .email)
        phone = try container.decode(String.self, forKey: .phone)
        
        let nameContainer = try container.nestedContainer(keyedBy: CodingKeys.NameCodingKeys.self, forKey: .name)
        let title = try nameContainer.decode(String.self, forKey: .title)
        let first = try nameContainer.decode(String.self, forKey: .first)
        let last = try nameContainer.decode(String.self, forKey: .last)
        name = "\(title.capitalizingFirstLetter()) \(first.capitalizingFirstLetter()) \(last.capitalizingFirstLetter())"
        
        let pictureContainer = try container.nestedContainer(keyedBy: CodingKeys.PictureCodingKeys.self, forKey: .picture)
        let thumbnail = try pictureContainer.decode(String.self, forKey: .thumbnail)
        let medium = try pictureContainer.decode(String.self, forKey: .medium)
        let large = try pictureContainer.decode(String.self, forKey: .large)
        picture = [thumbnail, medium, large]
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizedFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
