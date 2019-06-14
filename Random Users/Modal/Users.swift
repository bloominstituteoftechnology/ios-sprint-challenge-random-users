//
//  Users.swift
//  Random Users
//
//  Created by Hayden Hastings on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct Users: Decodable {
    
    var results: [User]
    
    enum UserCodingKeys: String, CodingKey {
        case results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UserCodingKeys.self)
        
        let results = try container.decode([User].self, forKey: .results)
        self.results = results
    }
    
}

struct User: Codable {
    
    var name: String
    let email: String
    let phone: String
    let imageThumbnailURL: URL
    let imageLargeURL: URL
    
    enum UserCodingKeys: String, CodingKey {
        
        case name
        case email
        case phone
        case picture
        
    }
    
    enum NameCodingKeys: String, CodingKey {
        case title, first, last
    }
    
    enum PictureCodingKeys: String, CodingKey {
        case large, medium, thumbnail
    }
    
    init(from decoder: Decoder) throws {
        let userContainer = try decoder.container(keyedBy: UserCodingKeys.self)
        
        let email = try userContainer.decode(String.self, forKey: .email)
        let phone = try userContainer.decode(String.self, forKey: .phone)
        
        let nameContainer = try userContainer.nestedContainer(keyedBy: NameCodingKeys.self, forKey: .name)
        
        let title = try nameContainer.decode(String.self, forKey: .title)
        let firstName = try nameContainer.decode(String.self, forKey: .first)
        let lastName = try nameContainer.decode(String.self, forKey: .last)
        let name = "\(title) \(firstName) \(lastName)"
        
        let pictureContainer = try userContainer.nestedContainer(keyedBy: PictureCodingKeys.self, forKey: .picture)
        
        let largeImageURL = try pictureContainer.decode(URL.self, forKey: .large)
        let thumbnailImageURL = try pictureContainer.decode(URL.self, forKey: .thumbnail)
        
        self.name = name
        self.email = email
        self.phone = phone
        self.imageLargeURL = largeImageURL
        self.imageThumbnailURL = thumbnailImageURL
    }
}


