//
//  RandomUser.swift
//  Random Users
//
//  Created by Austin Cole on 1/25/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct RandomUser: Decodable {
    let name: Name
    let email: String
    let phone: String
    let picture: Picture
    
    struct Name: Decodable {
        let title: String
        let first: String
        let last: String
    }
    struct Picture: Decodable {
        let large: String
        let thumbnail: String
    }
}

struct RandomUsers: Decodable {
    let results: [RandomUser]
    
}
