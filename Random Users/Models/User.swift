//
//  User.swift
//  Random Users
//
//  Created by Michael Stoffer on 8/3/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct User: Equatable, Codable {
    let name: String
    let phone: String
    let email: String
    let imageData: Data
}
