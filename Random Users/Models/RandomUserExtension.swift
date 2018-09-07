//
//  RandomUserExtension.swift
//  Random Users
//
//  Created by Lisa Sampson on 9/7/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

extension RandomUser: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case name
        case phoneNumber = "phone"
        case emailAddress = "email"
        case imageURLs = "pictures"
        
        enum NameCodingKeys: String, CodingKey {
            case title
            case first
            case last
        }
        
        enum ImageURLCodingKeys: String, CodingKey {
            case thumbnail
            case large
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let nameContainer = try container.nestedContainer(keyedBy: CodingKeys.NameCodingKeys.self, forKey: .name)
        let title = try nameContainer.decode(String.self, forKey: .title)
        let first = try nameContainer.decode(String.self, forKey: .first)
        let last = try nameContainer.decode(String.self, forKey: .last)
        
        let name = "\(title) \(first) \(last)"
       
        
        let phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
        let emailAddress = try container.decode(String.self, forKey: .emailAddress)
        
        let imageContainer = try container.nestedContainer(keyedBy: CodingKeys.ImageURLCodingKeys.self, forKey: .imageURLs)
        let thumbnailString = try imageContainer.decode(String.self, forKey: .thumbnail)
        let largeString = try imageContainer.decode(String.self, forKey: .large)
        
        let thumbnailImageURL = URL(string: thumbnailString)
        let largeImageURL = URL(string: largeString)
        
        self.name = name
        self.phoneNumber = phoneNumber
        self.emailAddress = emailAddress
        self.thumbnailImageURL = thumbnailImageURL
        self.largeImageURL = largeImageURL
    }
}
