//
//  RandomUser.swift
//  Random Users
//
//  Created by Rick Wolter on 12/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation
import Foundation

struct RandomUser: Codable {
    
    let results: [User]
}
    
    struct User: Codable {
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






