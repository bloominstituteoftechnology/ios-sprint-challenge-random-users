//
//  User.swift
//  Random Users
//
//  Created by Breena Greek on 5/15/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct User: Codable {
    let name: Name
    let imageURL: Image
}

struct Name: Codable {
    let title: String
    let first: String
    let last: String
}

struct Image: Codable {
    let thumbnail: String
}
