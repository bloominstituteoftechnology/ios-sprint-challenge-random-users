//
//  User.swift
//  Random Users
//
//  Created by Lambda_School_loaner_226 on 7/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct User: Codable {
    
    struct Name: Codable {
        let title: String
        let first: String
        let last: String
    }
    
    let name: String
    let phone: String
    let email: String
    let picture: String
}

extension User.Name: CustomStringConvertible {
    var description: String { return "\(title.capitalized) \(first.capitalized) \(last.capitalized)" }
}

extension User: CustomStringConvertible {
    var description: String {
        return "\(name)\n\(email)\n\(phone)"
    }
}
