//
//  RandomUsers.swift
//  Random Users
//
//  Created by Jesse Ruiz on 11/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct RandomUsers: Codable {
    
    let results: [Users]
}
    
    struct Users: Codable {
    let name : Name
    let email: String
    let dob: DOB
    let picture: Picture
    }
    
    struct Name: Codable {
        let first: String
        let last: String
    }
    
    struct DOB: Codable {
        let age: Int
    }
    
    struct Picture: Codable {
        let large: URL
        let thumbnail: URL
    }













