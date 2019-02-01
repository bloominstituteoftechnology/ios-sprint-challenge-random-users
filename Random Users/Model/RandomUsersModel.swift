//
//  RandomUsersModel.swift
//  Random Users
//
//  Created by Sergey Osipyan on 2/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct RandomUser: Codable {
    let results: [Result]
    
    
    struct Result: Codable {
        let name: Name
        let email: String
        let phone: String
        let picture: Picture
        
        struct Name: Codable {
            let first: String
            let last: String
        }
        
        struct Picture: Codable {
            let large: String
            let thumbnail: String
        }
    }
    
    enum RandomUserKeys: String, Codable {
        
        case results
        case name
        case phone
        case picture
        case first
        case last
        case large
        case thumbnil
        
    }
    
}
