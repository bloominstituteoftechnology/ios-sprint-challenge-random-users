//
//  User.swift
//  Random Users
//
//  Created by Victor  on 6/7/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct User {
    var name: String
    var title: String
    var phone: String
    var email: String
    var pictureUrl: URL
    var id: String = UUID().uuidString
    var picture: Data?
}

struct Users: Decodable, Equatable {
    let results: [User]
}

