//
//  User.swift
//  Random Users
//
//  Created by Ufuk Türközü on 13.03.20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

struct User: Codable {
    var name: String
    var picture: [URL]
    var email: String
    var phone: String
    
    enum UserKeys: String, CodingKey {
        case name
        case picture
        case email
        case phone
    }
    
    enum NameKeys: String, CodingKey {
        case title
        case first
        case last
    }
    
    enum PictureKeys: String, CodingKey {
        case thumbnail
        case large
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: UserKeys.self)
        let nameContainer = try container.nestedContainer(keyedBy: NameKeys.self, forKey: .name)
        let picContainer = try container.nestedContainer(keyedBy: PictureKeys.self, forKey: .picture)
        
        let title = try nameContainer.decode(String.self, forKey: .title)
        let first = try nameContainer.decode(String.self, forKey: .first)
        let last = try nameContainer.decode(String.self, forKey: .last)
        
        var picArr: [URL] = []
        
        let thumbnail = try picContainer.decode(String.self, forKey: .thumbnail)
        let largePic = try picContainer.decode(String.self, forKey: .large)
        
        if let thumbnailURL = URL(string: thumbnail), let largePicURL = URL(string: largePic) {
            
            picArr.append(thumbnailURL)
            picArr.append(largePicURL)
        }
        
        name = "\(title) \(first) \(last)"
        email = try container.decode(String.self, forKey: .email)
        phone = try container.decode(String.self, forKey: .phone)
        picture = picArr
        
    }
}

struct UserResults: Codable {
    let results: [User]
}
