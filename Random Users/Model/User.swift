//
//  User.swift
//  Random Users
//
//  Created by Ilgar Ilyasov on 10/12/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

struct User: Decodable {
    let name: String
    let phone: String
    let email: String
    let largeURL: URL!
    let thumbnailURL: URL!

    
    enum ResultsKeys: String, CodingKey {
        case name
        case phone
        case email
        case picture
        
        enum NameKeys: String, CodingKey {
            case title
            case first
            case last
        }
        
        enum PictureKeys: String, CodingKey {
            case large
            case thumbnail
        }
    }
    
    init(decoder: Decoder) throws {
        let resultsContainer = try decoder.container(keyedBy: ResultsKeys.self)
        
        // Decode name
        let nameContainer = try resultsContainer.nestedContainer(keyedBy: ResultsKeys.NameKeys.self, forKey: .name)
        let title = try nameContainer.decode(String.self, forKey: .title)
        let first = try nameContainer.decode(String.self, forKey: .first)
        let last = try nameContainer.decode(String.self, forKey: .last)
        let name = "\(title) \(first) \(last)"
        
        // Decode phone. email
        let phone = try resultsContainer.decode(String.self, forKey: .phone)
        let email = try resultsContainer.decode(String.self, forKey: .email)
        
        // Decode picture
        let pictureContainer = try resultsContainer.nestedContainer(keyedBy: ResultsKeys.PictureKeys.self, forKey: .picture)
        let largeURL = try pictureContainer.decode(URL.self, forKey: .large)
        let thumbnailURL = try pictureContainer.decode(URL.self, forKey: .thumbnail)
        
        // Assign decoded values to the model properties
        self.name = name
        self.phone = phone
        self.email = email
        self.largeURL = largeURL
        self.thumbnailURL = thumbnailURL
    }
}

struct Results: Decodable {
    var results: [User]
}
