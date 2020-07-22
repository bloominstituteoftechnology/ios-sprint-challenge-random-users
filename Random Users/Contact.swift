//
//  Contact.swift
//  Random Users
//
//  Created by Kenneth Jones on 7/21/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct Contacts: Codable {
    let results: [Contact]
    
    enum ResultsKeys: String, CodingKey {
        case results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ResultsKeys.self)
        
        results = try container.decode([Contact].self, forKey: .results)
    }
}

struct Contact: Codable {
    let name: String
    let phone: String
    let email: String
    let picture: URL
    let thumbnail: URL
    
    enum ContactKeys: String, CodingKey {
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
            case medium
            case thumbnail
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ContactKeys.self)
        
        phone = try container.decode(String.self, forKey: .phone)
        email = try container.decode(String.self, forKey: .email)
        
        let pictureContainer = try container.nestedContainer(keyedBy: ContactKeys.PictureKeys.self, forKey: .picture)
        picture = try pictureContainer.decode(URL.self, forKey: .medium)
        thumbnail = try pictureContainer.decode(URL.self, forKey: .thumbnail)
        
        let nameContainer = try container.nestedContainer(keyedBy: ContactKeys.NameKeys.self, forKey: .name)
        let title = try nameContainer.decode(URL.self, forKey: .title)
        let first = try nameContainer.decode(URL.self, forKey: .first)
        let last = try nameContainer.decode(URL.self, forKey: .last)
        name = "\(title) \(first) \(last)"
    }
}
