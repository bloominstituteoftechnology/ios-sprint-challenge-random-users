//
//  Users.swift
//  Random Users
//
//  Created by David Williams on 7/19/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct Users: Codable {
    
    var name: Name
    
    struct Name: Codable {
        var title: String
        var first: String
        var last: String
    }
    
    var phone: String
    var email: String
    var picture: Picture
    
    struct Picture: Codable {
        var medium: String
        var thumbnail: String
    }
    
}
