//
//  Users.swift
//  Random Users
//
//  Created by Hayden Hastings on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct User: Codable {
    
    let name: String
    let email: String
    let phone: String
    let imageThumbnailURL: String
    let imageLargeURL: String
    
}

struct Users: Codable {
    
    var users: [User] = []
    
    enum ResultCodingKeys: String, CodingKey {
        case results
    }
    
    enum UserCodingKeys: String, CodingKey {
        
        case name
        case email
        case phone
        case piture
        
    }
    
    enum NameCodingKeys: String, CodingKey {
        case title, first, last
    }
    
    enum PictureCodingKeys: String, CodingKey {
        case large, medium, thumbnail
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ResultCodingKeys.self)
        var resultsContainer = try container.nestedUnkeyedContainer(forKey: .results)
        
        while resultsContainer.isAtEnd == false {
            let userContainer = try resultsContainer.nestedContainer(keyedBy: UserCodingKeys.self)
            
            let email = try userContainer.decode(String.self, forKey: .email)
            let phone = try userContainer.decode(String.self, forKey: .phone)
            
            let nameContainer = try userContainer.nestedContainer(keyedBy: NameCodingKeys.self, forKey: .name)
            
            let title = try nameContainer.decode(String.self, forKey: .title)
            let firstName = try nameContainer.decode(String.self, forKey: .first)
            let lastName = try nameContainer.decode(String.self, forKey: .last)
            let name = "\(title) \(firstName) \(lastName)"
            
            let pictureContainer = try userContainer.nestedContainer(keyedBy: PictureCodingKeys.self, forKey: .piture)
            
            let largeImageURL = try pictureContainer.decode(String.self, forKey: .large)
            let thumbnailImageURL = try pictureContainer.decode(String.self, forKey: .thumbnail)
            
            let user = User(name: name, email: email, phone: phone, imageThumbnailURL: thumbnailImageURL, imageLargeURL: largeImageURL)
            
            users.append(user)
        }
    }
}
