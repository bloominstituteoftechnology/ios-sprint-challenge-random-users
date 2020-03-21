//
//  Contact.swift
//  Random Users
//
//  Created by Sal B Amer LpTop on 21/3/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//
// Get Model from https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000

import Foundation

// MARK: - Person
struct Results: Codable {
    var results: [Result]
}

// MARK: - Result
struct Result: Codable {
    var name: String
    var email: String
    var phone: String
    var picture: [URL]
    var thumbnailImage: URL
    var largeImage: URL
    
    enum ResultKeys: String, CodingKey {
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
        let container = try decoder.container(keyedBy: ResultKeys.self)
        // name container
        let nameContainer = try container.nestedContainer(keyedBy: ResultKeys.NameKeys.self, forKey: .name)
        let title = try nameContainer.decode(String.self, forKey: .title)
        let first = try nameContainer.decode(String.self, forKey: .first)
        let last = try nameContainer.decode(String.self, forKey: .last)
        
        // picture container
        let pictureContainer = try container.nestedContainer(keyedBy: ResultKeys.PictureKeys.self, forKey: .picture)
        var pictureURLs: [URL] = []
        let large = try pictureContainer.decode(String.self, forKey: .large)
        let medium = try pictureContainer.decode(String.self, forKey: .medium)
        let thumbnail = try pictureContainer.decode(String.self, forKey: .medium)
        
        if let largeURL = URL(string: large),
        let mediumURL = URL(string: medium),
        let thumbnailURL = URL(string: thumbnail) {
            pictureURLs.append(largeURL)
            pictureURLs.append(mediumURL)
            pictureURLs.append(thumbnailURL)
        }
        // use String concatenation to combine for display
        name = "\(title) \(first) \(last)"
        phone = try container.decode(String.self, forKey: .phone)
        email = try container.decode(String.self, forKey: .email)
        picture = pictureURLs
        thumbnailImage = URL(string: thumbnail)!
        largeImage = URL(string: large)!
        
    }
    
}
