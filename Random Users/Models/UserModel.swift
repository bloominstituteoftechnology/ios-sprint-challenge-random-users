//
//  UserModel.swift
//  Random Users
//
//  Created by Lotanna Igwe-Odunze on 1/25/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

struct Result: Codable {
    let results: [User]
}

struct User: Codable {
    let name: Name
    let email, cell: String
    let picture: Picture
}

struct Name: Codable {
    let title, first, last: String
}

struct Picture: Codable {
    let large, medium, thumbnail: String
}
