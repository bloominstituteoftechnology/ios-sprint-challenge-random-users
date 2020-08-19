//
//  User.swift
//  Random Users
//
//  Created by Ryan Murphy on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct User: Decodable {
    var name: Name
    var email: String
    var phone: String
    var picture: Pictrue
    
    struct Name: Decodable {
        var title: String
        var first: String
        var last: String

    }
    
    struct Pictrue: Decodable {
        var large: String
        var thumbnail: String
    }
}

struct Results: Decodable {
    let results: [User]
}
