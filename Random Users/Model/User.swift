//
//  User.swift
//  Random Users
//
//  Created by Bradley Yin on 9/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct User: Decodable {
    let title: String
    let first: String
    let last: String
    let email: String
    let phone: String
    let thumbnail: String
    let largePhoto: String
    
    enum CodingKeys: String, CodingKey {
        case result
        
        enum ResultCodingKeys: String, CodingKey {
            case name
            case email
            case phone
            case picture
            
            enum NameCodingKeys: String, CodingKey {
                case title
                case first
                case last
            }
            
            enum PictureCodingKeys: String, CodingKey {
                case large
                case thumbnail
            }
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var resultContainer = try container.nestedUnkeyedContainer(forKey: .result)
        let userContainer = try resultContainer.nestedContainer(keyedBy: CodingKeys.ResultCodingKeys.self)
        email = try userContainer.decode(String.self, forKey: .email)
        phone = try userContainer.decode(String.self, forKey: .phone)
        
        let NameContainer = try userContainer.nestedContainer(keyedBy: CodingKeys.ResultCodingKeys.NameCodingKeys.self, forKey: .name)
        title = try NameContainer.decode(String.self, forKey: .title)
        first = try NameContainer.decode(String.self, forKey: .first)
        last = try NameContainer.decode(String.self, forKey: .last)
        
        
        let pictureContainer = try userContainer.nestedContainer(keyedBy: CodingKeys.ResultCodingKeys.PictureCodingKeys.self, forKey: .picture)
        largePhoto = try pictureContainer.decode(String.self, forKey: .large)
        thumbnail = try pictureContainer.decode(String.self, forKey: .thumbnail)
    }
}

