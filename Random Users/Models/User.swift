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
    
    enum ResultsCodingKeys: String, CodingKey {
        case results
    }
    
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
        let container = try decoder.container(keyedBy: ResultsCodingKeys.self)
        let resultsContainer = try container.nestedContainer(keyedBy: UserCodingKeys.self, forKey: .results)
        
        let nameContainer = try resultsContainer.nestedContainer(keyedBy: NameCodingKeys.self, forKey: .name)
        title = try nameContainer.decode(String.self, forKey: .title)
        first = try nameContainer.decode(String.self, forKey: .first)
        last = try nameContainer.decode(String.self, forKey: .last)
        
        let pictureContainer = try resultsContainer.nestedContainer(keyedBy: PictureCodingKeys.self, forKey: .picture)
        thumbnail = try pictureContainer.decode(URL.self, forKey: .thumbnail)
        
        emailAddress = try resultsContainer.decode(String.self, forKey: .emailAddress)
        phoneNumber = try resultsContainer.decode(String.self, forKey: .phoneNumber)
        
    }
    
}



