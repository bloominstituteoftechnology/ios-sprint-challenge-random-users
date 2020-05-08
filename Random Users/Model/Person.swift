//
//  Model.swift
//  Random Users
//
//  Created by Cameron Collins on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation
// MARK: - Person
struct Person: Codable {
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
