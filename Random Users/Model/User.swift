//
//  User.swift
//  Random Users
//
//  Created by Kenny on 2/14/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct UserResults: Decodable {
    //=======================
    // MARK: - Types
    enum ResultKey: String, CodingKey {
        case results
    }
    
    //=======================
    // MARK: - Properties
    let results: [User]
    
    //=======================
    // MARK: - Init
    init(from decoder: Decoder) throws {
        let resultsContainer = try decoder.container(keyedBy: ResultKey.self)
        self.results = try resultsContainer.decode([User].self, forKey: .results)
    }
}

struct User: Decodable {
    //=======================
    // MARK: - Types
    enum NameKeys: String, CodingKey {
        case fname = "first"
        case lname = "last"
    }
    enum ImageKeys: String, CodingKey {
        case picture
        case thumbnailImage = "thumbnail"
        case largeImage = "large"
    }
    enum PhoneKey: String, CodingKey {
        case phone
    }
    enum EmailKey: String, CodingKey {
        case email
    }
    
    //=======================
    // MARK: - Properties
    let fname: String
    let lname: String
    let thumbnailImage: URL
    let largeImage: URL
    let phone: String
    let email: String
    
    //=======================
    // MARK: - Init
    init(from decoder: Decoder) throws {
        let nameContainer = try decoder.container(keyedBy: NameKeys.self)
        fname = try nameContainer.decode(String.self, forKey: .fname)
        lname = try nameContainer.decode(String.self, forKey: .lname)
        
        let pictureContainer = try decoder.container(keyedBy: ImageKeys.self)
        thumbnailImage = try pictureContainer.decode(URL.self, forKey: .thumbnailImage)
        largeImage = try pictureContainer.decode(URL.self, forKey: .largeImage)
        
        let phoneContainer = try decoder.container(keyedBy: PhoneKey.self)
        phone = try phoneContainer.decode(String.self, forKey: .phone)
        
        let emailContainer = try decoder.container(keyedBy: EmailKey.self)
        email = try emailContainer.decode(String.self, forKey: .email)
    }
}
