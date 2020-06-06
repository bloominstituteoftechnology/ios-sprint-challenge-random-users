//
//  User.swift
//  Random Users
//
//  Created by Cody Morley on 6/5/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct User: Codable {
    //MARK: - Types -
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case phoneNumber = "phone"
        case picture
        
        enum NameKeys: String, CodingKey {
            case title
            case firstName = "first"
            case lastName = "last"
        }
        
        enum ImageKeys: String, CodingKey {
            case image = "large"
            case thumbnail
        }
    }
    
    
    //MARK: - Properties -
    let name: [String]
    let email: String
    let phoneNumber: String
    let picture: [String]
    let image: String
    let thumbnail: String
    let firstName: String
    let lastName: String
    
    
}
