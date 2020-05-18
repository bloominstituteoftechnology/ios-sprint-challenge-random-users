//
//  User.swift
//  Random Users
//
//  Created by Juan M Mariscal on 5/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct User: Codable, Equatable {
    let name : Name
    let email : String
    let phone : String
}

struct Name: Codable, Equatable {
    let title : String
    let firstName : String
    let lastName : String
}

//struct UserResults: Decodable {
//    let results: [User]
//}
