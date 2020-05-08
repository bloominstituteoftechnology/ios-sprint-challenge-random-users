//
//  Users.swift .swift
//  Random Users
//
//  Created by Bhawnish Kumar on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct User: Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case phone
        case picture
    }
    
    let name: String
    let email: String
    let phone: String
    let picture: String
    
}
