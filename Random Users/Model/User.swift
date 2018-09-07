//
//  User.swift
//  Random Users
//
//  Created by Conner on 9/7/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation

struct User {
    let name: Name
    let email: String
    let phone: String
    let picture: Picture
}

struct Name {
    let title: String
    let first: String
    let last: String
}

struct Picture {
    let large: String
    let medium: String
    let thumbnail: String
}
