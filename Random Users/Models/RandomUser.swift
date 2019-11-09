//
//  RandomUser.swift
//  Random Users
//
//  Created by Vici Shaweddy on 11/9/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct RandomUser: Codable {
    let name: Name
    let email: String
    let phone: String
    let picture: Picture
}

extension RandomUser {
    var fullName: String {
        return "\(self.name.title) \(self.name.first) \(self.name.last)"
    }
}
