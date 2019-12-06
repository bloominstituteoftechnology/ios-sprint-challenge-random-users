//
//  RandomPerson.swift
//  Random Users
//
//  Created by Dennis Rudolph on 12/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct RandomPerson: Codable {
    var name: Name
    var email: String
    var phone: String
    var picture: Picture
}

struct Name: Codable {
    var title: String
    var first: String
    var last: String
}

struct Picture: Codable {
    var large: String
    var thumbnail: String
}
