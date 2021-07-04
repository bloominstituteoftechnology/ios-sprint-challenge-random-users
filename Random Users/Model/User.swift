//
//  User.swift
//  Random Users
//
//  Created by Julian A. Fordyce on 3/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit


struct User: Decodable {
    
    let name: String
    let email: String
    let phone: String
    let thumbURL: URL
    let largeURL: URL
    
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
            case large
            case thumbnail
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
        
        let name = "\(title.capitalized) \(first.capitalized) \(last.capitalized)"
        
        let thumbImageContainer = try container.nestedContainer(keyedBy: CodingKeys.PictureCodingKeys.self, forKey: .picture)
        
        let thumbURL = try thumbImageContainer.decode(URL.self, forKey: .thumbnail)
        
        let largeImageContainer = try container.nestedContainer(keyedBy: CodingKeys.PictureCodingKeys.self, forKey: .picture)
        
        let largeURL = try largeImageContainer.decode(URL.self, forKey: .large)
        
        self.name = name
        self.email = email
        self.phone = phone
        self.thumbURL = thumbURL
        self.largeURL = largeURL
    }
}
    
    struct Users: Decodable {
        let results: [User]
        
        enum UserCodingKeys: String, CodingKey {
            case results
        }
        
        init(from decoder: Decoder) throws {
            
            let container = try decoder.container(keyedBy: UserCodingKeys.self)
            
            let results = try container.decode([User].self, forKey: .results)
            self.results = results
        }
        
    }
    

