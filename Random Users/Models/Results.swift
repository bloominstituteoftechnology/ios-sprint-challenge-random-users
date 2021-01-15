//
//  Result.swift
//  Random Name
//
//  Created by Sammy Alvarado on 9/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct User: Codable {
    let results: [UsersResults]
}

struct UsersResults: Codable {
    let name: Name
    let email, phone: String
    let picture: Picture
//    let id: ID
}

//struct ID: Codable {
//    let name: String
//}

struct Name: Codable {
    let title, first, last: String
}

struct Picture: Codable {
    let large, medium, thumbnail: String
}

