//
//  User.swift
//  Random Users
//
//  Created by Matthew Martindale on 5/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct User: Codable {
    var name: Name
    var email: String
    var phone: String
    var picture: Picture
}

struct Name: Codable {
    var fullName: String
    var title: String
    var first: String
    var last: String
    
    init(fullName: String, title: String, first: String, last: String) {
        self.title = title
        self.first = first
        self.last = last
        self.fullName = "\(title) \(first) \(last)"
    }
}

struct Picture: Codable {
    var large: String
    var thumbnail: String
}
