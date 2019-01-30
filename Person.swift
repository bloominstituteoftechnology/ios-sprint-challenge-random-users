//
//  Person.swift
//  Random Users
//
//  Created by Simon Elhoej Steinmejer on 07/09/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation

struct Person: Decodable
{
    var name: Name
    var email: String
    var picture: Picture
//    var id: Id
    
    
    enum CodingKeys: String, CodingKey
    {
        case email
        case name
        case picture
//        case id
    }
    
    init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name = try container.decode(Name.self, forKey: .name)
        let email = try container.decode(String.self, forKey: .email)
        let picture = try container.decode(Picture.self, forKey: .picture)
//        let id = try container.decode(Id.self, forKey: .id)
        
        self.name = name
        self.email = email
        self.picture = picture
//        self.id = id
    }
    
    
    struct Name: Decodable
    {
        var title: String
        var first: String
        var last: String
        
        enum CodingKeys: String, CodingKey
        {
            case title
            case first
            case last
        }
        
        init(from decoder: Decoder) throws
        {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let title = try container.decode(String.self, forKey: .title)
            let first = try container.decode(String.self, forKey: .first)
            let last = try container.decode(String.self, forKey: .last)
            
            self.title = title
            self.first = first
            self.last = last
        }
    }
    
    struct Picture: Decodable
    {
        var thumbnail: String
        var large: String
        
        enum CodingKeys: String, CodingKey
        {
            case thumbnail
            case large
        }
        
        init(from decoder: Decoder) throws
        {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let thumbnail = try container.decode(String.self, forKey: .thumbnail)
            let large = try container.decode(String.self, forKey: .large)
            
            self.thumbnail = thumbnail
            self.large = large
        }
    }
    
//    struct Id: Decodable
//    {
//        var value: String
//
//        enum CodingKeys: String, CodingKey
//        {
//            case value
//        }
//
//        init(from decoder: Decoder) throws
//        {
//            let container = try decoder.container(keyedBy: CodingKeys.self)
//            let value = try container.decode(String.self, forKey: .value)
//
//            self.value = value
//        }
//    }
}

struct Results: Decodable
{
    var results: [Person]
}









