//
//  User.swift
//  Random Users
//
//  Created by Jake Connerly on 10/4/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct Results: Codable {
    let results: [User]
}

struct User: Codable {
    let name: Name
    let email: String
    let cellPhoneNumber: String
    let picture: Picture
    
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case cellPhoneNumber = "cell"
        case picture
    }
}

struct Name: Codable {
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first"
        case lastName = "last"
    }
}

struct Picture: Codable {
    let thumbNailURL: URL
    let largeImageURL: URL
    
    enum CodingKeys: String, CodingKey {
        case thumbNailURL = "thumbnail"
        case largeImageURL = "large"
    }
}
