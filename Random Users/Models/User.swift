//
//  User.swift
//  Random Users
//
//  Created by Elizabeth Wingate on 3/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct Result: Decodable {
    
    let name: [String: String]
    let email: String
    let phone: String
    let picture: [String: String]
    
    private enum CodingKeys: String, CodingKey {
        case name
        case email
        case phone
        case picture
    }
    
    private enum NameCodingKeys: String, CodingKey {
        case first
        case last
    }
    
    private enum PictureCodingKeys: String, CodingKey {
        case thumbnail
        case large
    }
}
