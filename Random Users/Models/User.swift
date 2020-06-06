//
//  User.swift
//  Random Users
//
//  Created by Cody Morley on 6/5/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct User: Codable {
    let name: String
    let email: String
    let userID: UUID
    let imageData: Data
}
