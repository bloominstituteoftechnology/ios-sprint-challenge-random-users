//
//  UserRepresentation.swift
//  Random Users
//
//  Created by Andrew Dhan on 9/7/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation

struct UserData: Codable {
    let results: [UserRepresentation]
}

struct UserRepresentation: Codable {
    let name: Name
    let email: String
    let phone: String
    let picture: Picture
}
struct Name: Codable{
    let title: String
    let first: String
    let last: String
}

struct Picture: Codable{
    let large: String
    let medium: String
    let thumbnail: String
}
