//
//  RandomUser.swift
//  Random Users
//
//  Created by Christopher Aronson on 6/7/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

// MARK: - RandomUser
struct RandomUser: Codable {
    let results: [Result]
}

// MARK: - Result
struct Result: Codable {
    let name: Name
    let email, phone: String
    let picture: Picture
}

// MARK: - Name
struct Name: Codable {
    let title, first, last: String
}

// MARK: - Picture
struct Picture: Codable {
    let large, medium, thumbnail: String
}
