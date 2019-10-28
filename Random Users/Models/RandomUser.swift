//
//  RandomUser.swift
//  Random Users
//
//  Created by Lisa Sampson on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

// MARK: - Results
struct RandomUsers: Decodable {
    
    let results: [RandomUser]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
    
    // MARK: - Results Decoder
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let results = try container.decode([RandomUser].self, forKey: .results)
        self.results = results
    }
}

// MARK: - RandomUser
struct RandomUser: Decodable {
    
    let name: String
    let email: String
    let phone: String
    let thumbnailImageURL: URL
    let largeImageURL: URL
    
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case phone
        case imageURL = "picture"
        
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
    
    // MARK: - RandomUser Decoder
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let nameContainer = try container.nestedContainer(keyedBy: CodingKeys.NameCodingKeys.self, forKey: .name)
        let title = try nameContainer.decode(String.self, forKey: .title)
        let first = try nameContainer.decode(String.self, forKey: .first)
        let last = try nameContainer.decode(String.self, forKey: .last)
        let name = "\(title.capitalized) \(first.capitalized) \(last.capitalized)"
        
        let email = try container.decode(String.self, forKey: .email)
        let phone = try container.decode(String.self, forKey: .phone)
        
        let thumbnailImageContainer = try container.nestedContainer(keyedBy: CodingKeys.PictureCodingKeys.self, forKey: .imageURL)
        let thumbnailImageURL = try thumbnailImageContainer.decode(URL.self, forKey: .thumbnail)
        
        let largeImageContainer = try container.nestedContainer(keyedBy: CodingKeys.PictureCodingKeys.self, forKey: .imageURL)
        let largeImageURL = try largeImageContainer.decode(URL.self, forKey: .large)
        
        (self.name, self.email, self.phone, self.thumbnailImageURL, self.largeImageURL) = (name, email, phone, thumbnailImageURL, largeImageURL)
    }
}
