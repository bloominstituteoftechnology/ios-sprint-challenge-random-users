//
//  User.swift
//  Random Users
//
//  Created by Enrique Gongora on 3/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct Results: Decodable {
    var results: [User]
}

struct User: Decodable {
    var name: String
    var email: String
    var phone: String
    var picture: [URL]
    var thumbnailImage: URL
    var largeImage: URL
    
    enum UserKeys: String, CodingKey {
        case name
        case email
        case phone
        case picture
        
        enum NameKeys: String, CodingKey {
            case title
            case first
            case last
            
        }
        enum PictureKeys: String, CodingKey {
            case large
            case medium
            case thumbnail
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UserKeys.self)
        
        // Name Container
        let nameContainer = try container.nestedContainer(keyedBy: UserKeys.NameKeys.self, forKey: .name)
        let title = try nameContainer.decode(String.self, forKey: .title)
        let first = try nameContainer.decode(String.self, forKey: .first)
        let last = try nameContainer.decode(String.self, forKey: .last)
        
        // Picture Container
        var pictureURLs: [URL] = []
        let pictureContainer = try container.nestedContainer(keyedBy: UserKeys.PictureKeys.self, forKey: .picture)
        let large = try pictureContainer.decode(String.self, forKey: .large)
        let medium = try pictureContainer.decode(String.self, forKey: .medium)
        let thumbnail = try pictureContainer.decode(String.self, forKey: .thumbnail)
        if let largeURL = URL(string: large), let mediumURL = URL(string: medium), let thumbnailURL = URL(string: thumbnail) {
            pictureURLs.append(largeURL)
            pictureURLs.append(mediumURL)
            pictureURLs.append(thumbnailURL)
        }
        
        
        name = "\(title) \(first) \(last)"
        email = try container.decode(String.self, forKey: .email)
        phone = try container.decode(String.self, forKey: .phone)
        picture = pictureURLs
        thumbnailImage = URL(string: thumbnail)!
        largeImage = URL(string: large)!
    }
}
