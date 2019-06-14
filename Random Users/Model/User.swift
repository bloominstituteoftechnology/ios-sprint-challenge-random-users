//
//  User.swift
//  Random Users
//
//  Created by Mitchell Budge on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class Results: Codable, Equatable {
    let results: String
}

class User: Results, Codable, Equatable {
    let name: Name
    let email: String
    let phone: String
    let picture: Picture
}

class Name: Codable, Equatable {
    let title: String
    let first: String
    let last: String
}

class Picture: Codable, Equatable {
    let large: String
    let thumbnail: String
}

