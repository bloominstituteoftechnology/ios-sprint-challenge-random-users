//
//  User.swift
//  Random Users
//
//  Created by Fabiola S on 11/8/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct User: Equatable, Decodable {
    let name: String
    let phone: String
    let email: String
    let thumbnailImage: URL
    let largeImage: URL
    
    init(name: String, phone:String, email:String, thumbnailImage: URL, largeImage: URL) {
        self.name = name
        self.phone = phone
        self.email = email
        self.thumbnailImage = thumbnailImage
        self.largeImage = largeImage
    }
}
