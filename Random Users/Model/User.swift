//
//  User.swift
//  Random Users
//
//  Created by Juan M Mariscal on 7/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct User: Codable, Hashable,Equatable {
    
    let name: Name
    let email: String
    let phone: String
    let picture: Picture
    
    struct Name: Codable, Hashable, Equatable {
        let title: String
        let first: String
        let last: String
    }
    
    struct Picture: Codable, Hashable, Equatable {
        let large: String
        let medium: String
        let thumbnail: String
    }
    
}

struct UserResults: Decodable {
    let results: [User]
}
