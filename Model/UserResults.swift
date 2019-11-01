//
//  UserResults.swift
//  Random Users
//
//  Created by Jonalynn Masters on 11/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct UserResults: Codable {
    var results: [User]
}

struct User: Codable {
    var name: Name
    var email: String
    var phone: String
    var picture: Photos
    }

struct Name: Codable {
    var title: String
    var first: String
    var last: String
}

struct Photos: Codable {
    var large: URL
    var medium: URL
    var thumbnail: URL
}
}
