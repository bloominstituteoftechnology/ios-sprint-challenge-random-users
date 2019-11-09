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
    let emailAddress: String
    let phoneNumber: String
    let thumbnail: URL
    
    enum UserCodingKeys: String, CodingKey {
        case name
        case emailAddress
        case phoneNumber
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
        let container = try decoder.container(keyedBy: UserCodingKeys.self)
        
        let nameContainer = try container.nestedContainer(keyedBy: NameCodingKeys.self, forKey: .name)
        title = try nameContainer.decode(String.self, forKey: .title)
        first = try nameContainer.decode(String.self, forKey: .first)
        last = try nameContainer.decode(String.self, forKey: .last)
        
        let pictureContainer = try container.nestedContainer(keyedBy: PictureCodingKeys.self, forKey: .picture)
        thumbnail = try pictureContainer.decode(URL.self, forKey: .thumbnail)
        
        emailAddress = try container.decode(String.self, forKey: .emailAddress)
        phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
        
    }
    
}



