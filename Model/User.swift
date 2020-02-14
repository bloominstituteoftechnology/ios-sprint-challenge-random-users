//
//  User.swift
//  Random Users
//
//  Created by Austin Potts on 2/14/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

// Regular parsing models. These will be changed to manual conformance once testing is success
struct UserResults: Decodable {
    let results: [User]
}


struct User: Decodable {
    var name: Name
    var email: String
    var phone: String
    var picture: Picture
    
}

struct Name: Decodable {
    let first: String
    let last: String
}

struct Picture: Decodable {
    var thumbnail: URL
    var large: URL
}
