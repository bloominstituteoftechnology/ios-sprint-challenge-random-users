//
//  User.swift
//  Random Users
//
//  Created by Bobby Keffury on 11/9/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct User: Codable {
    
    let title: String
    let first: String
    let last: String
    let email: String
    let phone: String
    let thumbnail: URL
    
    enum ResultsCodingKeys: String, CodingKey {
        case results
    }
    
    enum UserCodingKeys: String, CodingKey {
        case name
        case email
        case phone
        case picture
    }
    
    enum NameCodingKeys: String, CodingKey {
        case title
        case first
        case last
    }
    
    enum PictureCodingKeys: String, CodingKey {
        case thumbnail
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ResultsCodingKeys.self)
        
        
        var resultsContainer = try container.nestedUnkeyedContainer(forKey: .results)
        
        let nameContainer = try resultsContainer.nestedContainer(keyedBy: NameCodingKeys.self)
        title = try nameContainer.decode(String.self, forKey: .title)
        first = try nameContainer.decode(String.self, forKey: .first)
        last = try nameContainer.decode(String.self, forKey: .last)
               
        email = try resultsContainer.decode(String.self)
        phone = try resultsContainer.decode(String.self)
               
        let pictureContainer = try resultsContainer.nestedContainer(keyedBy: PictureCodingKeys.self)
        thumbnail = try pictureContainer.decode(URL.self, forKey: .thumbnail)
        
       
        
        
        
        
//
//        let nameContainer = try resultsContainer.nestedContainer(keyedBy: NameCodingKeys.self, forKey: .name)
//        title = try nameContainer.decode(String.self, forKey: .title)
//        first = try nameContainer.decode(String.self, forKey: .first)
//        last = try nameContainer.decode(String.self, forKey: .last)
//
//        let pictureContainer = try resultsContainer.nestedContainer(keyedBy: PictureCodingKeys.self, forKey: .picture)
//        thumbnail = try pictureContainer.decode(URL.self, forKey: .thumbnail)
//
//        email = try resultsContainer.decode(String.self, forKey: .email)
//        phone = try resultsContainer.decode(String.self, forKey: .phone)
        
    }
    
}



