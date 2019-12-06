//
//  User.swift
//  Random Users
//
//  Created by morse on 12/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation



struct User: Decodable {
    let name: String
    let phone: String
    let email: String
    let thumbnail: String
    let photo: String
    
    enum UserCodingKeys: String, CodingKey {
        case name, phone, email, thumbnail, photo, picture
    }
    
    enum NameCodingKeys: String, CodingKey {
        case first, last
    }
    
    enum PictureContainerCodingKeys: String, CodingKey {
        case medium, thumbnail
    }
    
    
}
