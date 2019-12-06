//
//  User.swift
//  Random Users
//
//  Created by Niranjan Kumar on 12/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct RandomUsers: Codable {
    let results: [User]
    
}

struct User: Codable {
    let name: [Name]
    let email: String
    let phone: String
    let picture: [Picture]
    
}

struct Name: Codable {
    let first: String
    let last: String
}

struct Picture: Codable {
    let thumbnail: URL
    let large: URL
}
