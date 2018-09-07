//
//  User.swift
//  Random Users
//
//  Created by Carolyn Lea on 9/7/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

struct Name: Codable, Equatable
{
    var title: String
    var firstName: String
    var lastName: String
    
    init(title: String, firstName: String, lastName: String)
    {
        self.title = title
        self.firstName = firstName
        self.lastName = lastName
    }
    
    enum NameCodingKeys: String, CodingKey
    {
        case title
        case first
        case last
    }
    
    init(from decoder: Decoder) throws
    {
        let nameContainer = try decoder.container(keyedBy: NameCodingKeys.self)
        
        let title = try nameContainer.decode(String.self, forKey: .title)
        let firstName = try nameContainer.decode(String.self, forKey: .first)
        let lastName = try nameContainer.decode(String.self, forKey: .last)
        
        self.title = title
        self.firstName = firstName
        self.lastName = lastName
    }
    
    func encode(to encoder: Encoder) throws
    {
        var nameContainer = encoder.container(keyedBy: NameCodingKeys.self)
        
        try nameContainer.encode(title, forKey: .title)
        try nameContainer.encode(firstName, forKey: .first)
        try nameContainer.encode(lastName, forKey: .last)
    }
}


struct User: Codable, Equatable
{
    var name: String
    var thumbnail: URL
    var image: URL
    var email: String
    var phone: String
    var identifier: [String:String]
    
    init(name: String, thumbnail: URL, image: URL, email: String, phone: String, identifier: [String:String])
    {
        self.name = name
        self.thumbnail = thumbnail
        self.image = image
        self.email = email
        self.phone = phone
        self.identifier = identifier
    }
    
    enum CodingKeys: String, CodingKey
    {
        case name
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
        
        enum NameCodingKeys: String, CodingKey
        {
            
            case first
            
        }
        
    }
    
    init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let nameContainer = try decoder.container(keyedBy: CodingKeys.NameCodingKeys.self)
        let name = try nameContainer.decode(String.self, forKey: .first)
        
        let thumbnail = try container.decode(URL.self, forKey: .thumbnail)
        
        let image = try container.decode(URL.self, forKey: .image)
        
        let email = try container.decode(String.self, forKey: .email)
        
        let phone = try container.decode(String.self, forKey: .phone)
        
        let identifier = try container.decode([String:String].self, forKey: .identifier)
        
        self.name = name
        self.thumbnail = thumbnail
        self.image = image
        self.email = email
        self.phone = phone
        self.identifier = identifier
    }
    
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        
        try container.encode(thumbnail, forKey: .thumbnail)
        
        try container.encode(image, forKey: .image)
        
        try container.encode(email, forKey: .email)
        
        try container.encode(phone, forKey: .phone)
        
        try container.encode(identifier, forKey: .identifier)
    }
}

struct Users: Codable, Equatable
{
    let users: [User]
}

