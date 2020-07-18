//
//  User.swift
//  Random Users
//
//  Created by Lambda_School_loaner_226 on 7/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct User: Codable, Hashable, Equatable {
    
    struct Picture: Codable, Hashable, Equatable {
        let large: String
        let medium: String
        let thumbnail: String
    }
    
    struct Name: Codable, Hashable, Equatable {
        let title: String
        let first: String
        let last: String
    }
    
    let picture: Picture
    let name: Name
    let email: String
    let phone: String
}
