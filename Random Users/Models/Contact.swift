//
//  Contact.swift
//  Random Users
//
//  Created by scott harris on 3/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct Contact: Codable {
    
    enum CodingKeys: String, CodingKey {
        case email
        case phone
        case thumbnailURL
        case imageURL
        case title
        case firstName
        case lastName
        
        
        enum NameContainerKeys: String, CodingKey {
            case name
            
            enum NameKeys: String, CodingKey {
                case title
                case firstName = "first"
                case lastName = "last"
            }
        }
        
        
        enum PictureContainerKeys: String, CodingKey {
            case picture
            
            enum PictureKeys: String, CodingKey {
                case large
                case thumbnail
            }
        }
        
    }
    
    let title: String
    let firstName: String
    let lastName: String
    let email: String
    let phone: String
    let thumbnailURL: URL
    let imageURL: URL
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        email = try container.decode(String.self, forKey: .email)
        phone = try container.decode(String.self, forKey: .phone)
        
        let nameContainerKeys = try decoder.container(keyedBy: CodingKeys.NameContainerKeys.self)
        let nameContainer = try nameContainerKeys.nestedContainer(keyedBy: CodingKeys.NameContainerKeys.NameKeys.self, forKey: .name)
        
        firstName = try nameContainer.decode(String.self, forKey: .firstName)
        lastName = try nameContainer.decode(String.self, forKey: .lastName)
        title = try nameContainer.decode(String.self, forKey: .title)
        
        let pictureContainerKeys = try decoder.container(keyedBy: CodingKeys.PictureContainerKeys.self)
        let pictureContainer = try pictureContainerKeys.nestedContainer(keyedBy: CodingKeys.PictureContainerKeys.PictureKeys.self, forKey: .picture)
        thumbnailURL = try pictureContainer.decode(URL.self, forKey: .thumbnail)
        imageURL = try pictureContainer.decode(URL.self, forKey: .large)
        
    }
    
}

struct ContactResults: Codable {
    let results: [Contact]
}
