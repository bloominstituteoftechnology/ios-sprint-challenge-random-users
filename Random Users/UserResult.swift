//
//  UserResult.swift
//  Random Users
//
//  Created by Ian French on 7/19/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation
struct UserResults: Codable {
    let name: Name
    let email: String
    let phone: String
    let picture: UserPicture
}

struct Name: Codable {
    let title: String
    let first: String
    let last: String
}

struct UserPicture: Codable {
    let large: String
    let medium: String
    let thumbnail: String
}

struct RandomUsersResults: Codable {
    let results: [UserResults]
}
