//
//  Contact.swift
//  Random Users
//
//  Created by Tobi Kuyoro on 10/04/2020.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct ContactResults: Decodable {
    var results: [Contact]
}

struct Contact: Decodable {
    var name: String
    var email: String
    var phone: String
    var pictures: [URL]
    
    enum ContactKeys: String, CodingKey {
        case name, email, phone
        case pictures = "picture"
    }
    
    enum NameKeys: String, CodingKey {
        case title, first, last
    }
    
    enum PictureKeys: String, CodingKey {
        case large, medium, thumbnail
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ContactKeys.self)
        let nameContainer = try container.nestedContainer(keyedBy: NameKeys.self, forKey: .name)
        let pictureContainer = try container.nestedContainer(keyedBy: PictureKeys.self, forKey: .pictures)
        
        let title = try nameContainer.decode(String.self, forKey: .title)
        let firstName = try nameContainer.decode(String.self, forKey: .first)
        let lastName = try nameContainer.decode(String.self, forKey: .last)
        
        let largeImage = try pictureContainer.decode(String.self, forKey: .large)
        let mediumImage = try pictureContainer.decode(String.self, forKey: .medium)
        let thumbnailImage = try pictureContainer.decode(String.self, forKey: .thumbnail)
        
        var pictures: [URL] = []
        if let largeImageURL = URL(string: largeImage),
            let mediumImageURL = URL(string: mediumImage),
            let thumbnailImageURL = URL(string: thumbnailImage) {
            pictures.append(largeImageURL)
            pictures.append(mediumImageURL)
            pictures.append(thumbnailImageURL)
        }
        
        self.name = "\(title) \(firstName) \(lastName)"
        self.email = try container.decode(String.self, forKey: .email)
        self.phone = try container.decode(String.self, forKey: .phone)
        self.pictures = pictures
    }
}
