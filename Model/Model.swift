//
//  Model.swift
//  Random Users
//
//  Created by Alex Thompson on 1/25/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct Results: Decodable {
    let results: [User]
}

struct User: Decodable {
    let name: String
    let picture: [String]
    let email: String
    let phone: String
    
    enum CodingKeys: String, CodingKey {
        case email
        case phone
        case name
        case picture
        
        enum NameCodingKey: String, CodingKey {
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
        
        let nameContainer = try container.nestedContainer(keyedBy: CodingKeys.NameCodingKey.self, forKey: .name)
        let title = try nameContainer.decode(String.self, forKey: .title)
        let first = try nameContainer.decode(String.self, forKey: .first)
        let last = try nameContainer.decode(String.self, forKey: .last)
        name = "\(title.capitilizingFirstLetter()) \(first.capitilizingFirstLetter()) \(last.capitilizingFirstLetter())"
        
        let pictureContainer = try container.nestedContainer(keyedBy: CodingKeys.PictureCodingKeys.self, forKey: .picture)
        let thumbnail = try pictureContainer.decode(String.self, forKey: .thumbnail)
        let medium = try pictureContainer.decode(String.self, forKey: .medium)
        let large = try pictureContainer.decode(String.self, forKey: .large)
        picture = [thumbnail, medium, large]
    }
}

extension String {
    func capitilizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitilizingFirstLetter()
    }
}
