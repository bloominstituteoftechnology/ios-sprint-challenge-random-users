//
//  User.swift
//  Random Users
//
//  Created by Ilgar Ilyasov on 10/12/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

struct User: Decodable {
    
    // MARK: - Properties
    
    let name: String
    let phone: String?
    let email: String
    let largeURL: URL?
    let thumbnailURL: URL?

    // MARK: - Coding Keys
    
    enum CodingKeys: String, CodingKey {
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
            case large
            case thumbnail
        }
    }
    
    enum Pictures {
        case large
        case thumbnail
    }
    
    // MARK: - Decoding
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode name
        let nameContainer = try container.nestedContainer(keyedBy: CodingKeys.NameKeys.self, forKey: .name)
        let title = try nameContainer.decode(String.self, forKey: .title).capitalized
        let first = try nameContainer.decode(String.self, forKey: .first).capitalized
        let last = try nameContainer.decode(String.self, forKey: .last).capitalized
        let name = "\(title) \(first) \(last)"
        
        // Decode phone. email
        let phone = try container.decode(String.self, forKey: .phone)
        let email = try container.decode(String.self, forKey: .email)
        
        // Decode picture
        let pictureContainer = try container.nestedContainer(keyedBy: CodingKeys.PictureKeys.self, forKey: .picture)
        let largeURL = try pictureContainer.decode(URL.self, forKey: .large)
        let thumbnailURL = try pictureContainer.decode(URL.self, forKey: .thumbnail)
        
        // Assign decoded values to the model properties
        self.name = name
        self.phone = phone
        self.email = email
        self.largeURL = largeURL
        self.thumbnailURL = thumbnailURL
    }
}

// MARK: - Top Level Model

struct Results: Decodable {
    var results: [User]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
}
