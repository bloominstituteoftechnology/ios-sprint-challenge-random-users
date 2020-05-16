//
//  User.swift
//  Random Users
//
//  Created by Lambda_School_loaner_226 on 5/16/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class User: Codable {
    
    struct Name: Codable {
        let first: String
        let last: String
    }
    
    struct Image: Codable {
        let smallImage: String
        let mediumImage: String
        let largeImage: String
    }
    
    let name: Name
    let phone: String
    let email: String
}
