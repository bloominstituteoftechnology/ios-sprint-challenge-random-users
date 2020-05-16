//
//  User.swift
//  Random Users
//
//  Created by Jarren Campos on 5/15/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct User: Codable {
    let picture: String
    let name: Name
    let phone: String
    let email: String
}
