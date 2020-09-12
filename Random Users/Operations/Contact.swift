//
//  Contact.swift
//  Random Users
//
//  Created by Gladymir Philippe on 9/11/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct ContactResults: Codable {
    let results: [Contact]
}

struct Contact: Codable {
    let name: Name
    let email: String
    let phone: String
    let picture: Picture
}

struct Name: Codable {
    let title: String
    let first: String
    let last: String
}

struct Picture: Codable {
    let thumbnail: String
    let medium: String
    let large: String
}
