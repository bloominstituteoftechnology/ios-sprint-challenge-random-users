//
//  UserModel.swift
//  Random Users
//
//  Created by Lotanna Igwe-Odunze on 11/30/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation
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
