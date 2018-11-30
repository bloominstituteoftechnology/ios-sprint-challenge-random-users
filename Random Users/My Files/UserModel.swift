//
//  UserModel.swift
//  Random Users
//
//  Created by Lotanna Igwe-Odunze on 11/30/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

struct User: Codable {
    let results: [Result]
}

struct Result: Codable {
    let name: Name
    let email, phone: String
    let picture: Picture
}

struct Name: Codable {
    let first, last: String
}

struct Picture: Codable {
    let large, thumbnail: String
}
