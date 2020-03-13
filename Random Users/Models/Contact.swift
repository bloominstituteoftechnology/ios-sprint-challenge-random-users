//
//  Contact.swift
//  Random Users
//
//  Created by Tobi Kuyoro on 13/03/2020.
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
        case name
        case email
        case phone
        case pictures = "picture"
    }
    
    enum NameKeys: String, CodingKey {
        case title
        case firstName = "first"
        case lastName = "last"
    }
    
    enum PictureKeys: String, CodingKey {
        case large
        case thumbnail
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ContactKeys.self)
        
        let nameContainer = try container.nestedContainer(keyedBy: NameKeys.self, forKey: .name)
        let title = try nameContainer.decode(String.self, forKey: .title)
        let firstName = try nameContainer.decode(String.self, forKey: .firstName)
        let lastName = try nameContainer.decode(String.self, forKey: .lastName)
        
        let pictureContainer = try container.nestedContainer(keyedBy: PictureKeys.self, forKey: .pictures)
        let largePictureString = try pictureContainer.decode(String.self, forKey: .large)
        let thumbnailString = try pictureContainer.decode(String.self, forKey: .thumbnail)
        
        var pictures: [URL] = []
        
        if let largePicture = URL(string: largePictureString),
            let thumbnailPicture = URL(string: thumbnailString) {
            pictures.append(largePicture)
            pictures.append(thumbnailPicture)
        }
        
        self.name = "\(title) \(firstName) \(lastName)"
        self.email = try container.decode(String.self, forKey: .email)
        self.phone = try container.decode(String.self, forKey: .phone)
        self.pictures = pictures
    }
}
