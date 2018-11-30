//
//  UserModel.swift
//  Random Users
//
//  Created by Jerrick Warren on 11/30/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

struct User: Decodable {
    
    let name: String
    let email: String
    let phone: String
    let thumbnailURL: URL
    let fullSizeURL: URL
    
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case phone
        case picture
        
        enum NameCodingKeys: String, CodingKey {
            case title
            case first
            case last
        }
        
        enum PictureCodingKeys: String, CodingKey {
            case large // for the DetailVC
            case thumbnail // for the tableVC
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let email = try container.decode(String.self, forKey: .email)
        let phone = try container.decode(String.self, forKey: .phone)
        
        let nameContainer = try container.nestedContainer(keyedBy: CodingKeys.NameCodingKeys.self, forKey: .name)
        let title = try nameContainer.decode(String.self, forKey: .title)
        let first = try nameContainer.decode(String.self, forKey: .first)
        let last = try nameContainer.decode(String.self, forKey: .last)
        
        let fullName = "\(title.capitalized) "+" \(first.capitalized) "+" \(last.capitalized)"
        
        
        let imageContainer = try container.nestedContainer(keyedBy: CodingKeys.PictureCodingKeys.self, forKey: .picture)
        let thumbnailString = try imageContainer.decode(String.self, forKey: .thumbnail)
        let thumbnailURL = URL(string: thumbnailString)!
        
        let fullSizeString = try imageContainer.decode(String.self, forKey: .large)
        let fullSizeURL = URL(string: fullSizeString)!
        
        self.email = email
        self.phone = phone
        self.name = fullName
        self.thumbnailURL = thumbnailURL
        self.fullSizeURL = fullSizeURL
    }
    
}


struct Results: Decodable {
    let results: [User]
}
