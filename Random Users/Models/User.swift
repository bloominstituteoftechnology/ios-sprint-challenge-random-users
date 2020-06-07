//
//  User.swift
//  Random Users
//
//  Created by Cody Morley on 6/5/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct User: Decodable {
    //MARK: - Types -
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case phoneNumber = "phone"
        case picture
        
        enum NameKeys: String, CodingKey {
            case title
            case first
            case last
        }
        
        enum ImageKeys: String, CodingKey {
            case image = "large"
            case thumbnail
        }
    }
    
    
    //MARK: - Properties -
    let title: String
    let name: String
    let email: String
    let phoneNumber: String
    let image: URL
    let thumbnail: URL
    
    
    //MARK: - Initializers -
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.email = try container.decode(String.self, forKey: .email)
        self.phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
        
        let nameContainer = try container.nestedContainer(keyedBy: CodingKeys.NameKeys.self, forKey: .name)
        let first = try nameContainer.decode(String.self, forKey: .first)
        let last = try nameContainer.decode(String.self, forKey: .last)
        self.name = "\(first) \(last)"
        self.title = try nameContainer.decode(String.self, forKey: .title)
        
        let imageContainer = try container.nestedContainer(keyedBy: CodingKeys.ImageKeys.self, forKey: .picture)
        let thumbnailString = try imageContainer.decode(String.self, forKey: .thumbnail)
        let imageString = try imageContainer.decode(String.self, forKey: .image)
        self.thumbnail = URL(string: thumbnailString)!
        self.image = URL(string: imageString)!
    }
    
    
}


