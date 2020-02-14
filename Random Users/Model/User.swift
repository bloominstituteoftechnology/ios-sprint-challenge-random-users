//
//  User.swift
//  Random Users
//
//  Created by Kenny on 2/14/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct UserResults: Decodable {
    let results: [User]
}

struct User: Decodable {
    //=======================
    // MARK: - Types
    enum NameKeys: String, CodingKey {
        case fname = "first"
        case lname = "last"
    }
    
    enum ImageKeys: String, CodingKey {
        case thumbnailImage = "thumbnail"
        case largeImage = "large"
    }
    
    //=======================
    // MARK: - Properties
    let fname: String
    let lname: String
    let thumbnailImage: URL
    let largeImage: URL
}
