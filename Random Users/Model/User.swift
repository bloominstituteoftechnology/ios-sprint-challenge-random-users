//
//  User.swift
//  Random Users
//
//  Created by Nathanael Youngren on 3/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct Results: Decodable {
    let results: [User]
}

struct User: Decodable {
    var name: Name
    var email: String
    var phone: String
    var picture: Picture
    
    struct Name: Decodable {
        var title: String
        var first: String
        var last: String
    }
    
    struct Picture: Decodable {
        var large: String
        var thumbnail: String
    }
}
