//
//  User.swift
//  Random Users
//
//  Created by Breena Greek on 5/15/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

// MARK: - User
struct User: Codable, Equatable, Hashable {
    let name: Name
    let picture: Picture
    let email: String
    let phone: String
    
    // MARK: - Name
    struct Name: Codable, Equatable, Hashable {
        let title, first, last: String
    }
    
    // MARK: - Picture
    struct Picture: Codable, Equatable, Hashable {
        let large, medium, thumbnail: String
    }
}

