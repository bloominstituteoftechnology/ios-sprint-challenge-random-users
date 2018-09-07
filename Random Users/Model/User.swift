//
//  User.swift
//  Random Users
//
//  Created by Carolyn Lea on 9/7/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation

struct Name: Codable
{
    var title: String
    var firstName: String
    var lastName: String
    
    enum NameCodingKeys: String, CodingKey
    {
        case title
        case first
        case last
    }
}


struct User: Codable
{
    var nameComponents: [Name]
    var thumbnail: Data
    var image: Data
    var email: String
    var phone: String
    var identifier: [String:String]
    
    enum CodingKeys: String, CodingKey
    {
        case nameComponents = "name"
        case thumbnail
        case image = "large"
        case email
        case phone
        case identifier = "id"
        
        enum idCodingKeys: String, CodingKey
        {
            case name
            case value
        }
    }
}



