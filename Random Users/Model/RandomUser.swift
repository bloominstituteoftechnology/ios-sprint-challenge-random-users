//
//  RandomUser.swift
//  Random Users
//
//  Created by Sameera Roussi on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct RandomUser: Equatable, Decodable {
    var name: String?
    var phoneNumber: String?
    var email: String?
    var thumbNailURL: URL?
    var largeImageURL: URL?
    
    enum UserImages: String {
        case thumbnail
        case large
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case phoneNumber = "phone"
        case email
        case imagesURL = "picture"
    
    enum UserNameKeys: String, CodingKey {
        case title
        case first
        case last
    }
    
    enum ImageURLKeys: String, CodingKey {
        case thumbnail
        case large
    }
}

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode the user name
        let nameContainer = try container.nestedContainer(keyedBy: CodingKeys.UserNameKeys.self, forKey: .name)
        let title = try nameContainer.decode(String.self, forKey: .title)
        let first = try nameContainer.decode(String.self, forKey: .first)
        let last = try nameContainer.decode(String.self, forKey: .last)
        let titleTypes: [String] = ["mrs", "ms", "mr"]
        let titlePuctuation = titleTypes.contains(title)  ?  "." : ""
        let name = "\(title.firstCapitalized)\(titlePuctuation) \(first.firstCapitalized) \(last.firstCapitalized)"
        
        // Decode phone number
        let phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
        
        // Decode email address
        let email = try container.decode(String.self, forKey: .email)
        
        // Decode images URL strings
        let imagesContainer = try container.nestedContainer(keyedBy: CodingKeys.ImageURLKeys.self, forKey: .imagesURL)
        let thumbnailString = try imagesContainer.decode(String.self, forKey: .thumbnail)
        let largeImageString = try imagesContainer.decode(String.self, forKey: .large)
        
        // Now create image URLs
        let thumbnailURL = URL(string: thumbnailString)
        let largeImageURL = URL(string: largeImageString)
        
        // Create the user data fields
        self.name = name
        self.phoneNumber = phoneNumber
        self.email = email
        self.thumbNailURL = thumbnailURL
        self.largeImageURL = largeImageURL
    }
}

// 1000 random users
struct RandomUsers: Decodable {
    enum CodingKeys: String, CodingKey {
        case randomUsers = "results"
    }
    
    var randomUsers: [RandomUser]
}

extension String {
    var firstCapitalized: String {
        return prefix(1).capitalized + dropFirst()
    }
}
