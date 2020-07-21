//
//  User.swift
//  Random Users
//
//  Created by Lambda_School_loaner_226 on 7/20/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct User: Codable, Hashable {
    struct Name: Codable, Hashable {
        let title: String
        let first: String
        let last: String
    }
    
    struct Picture: Codable, Hashable {
        let large: String
        let medium: String
        let thumbnail: String
    }
    
    let picture: Picture
    let name: Name
    let email: String
    let phone: String
}

extension User: CustomStringConvertible {
    var description: String {
        return "\(name)\n\(email)\n\(phone)"
    }
}

extension User.Name: CustomStringConvertible {
    var description: String { return "\(title.capitalized) \(first.capitalized) \(last.capitalized)" }
}

