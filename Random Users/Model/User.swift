//
//  User.swift
//  Random Users
//
//  Created by Marc Jacques on 10/4/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct UserResult: Decodable {
    let result: [User] = [] //because everything in the APi is in an array called results
}

struct User: Decodable {
    var name: Name
    var email: String
    var phone: String
    var picture: Picture
}

struct Name: Decodable {
    var first: String
    var last: String
}

struct Picture: Decodable {
    var thumbnail: URL
    var large: URL
}
