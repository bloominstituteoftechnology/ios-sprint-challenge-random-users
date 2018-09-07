//
//  User.swift
//  Random Users
//
//  Created by Linh Bouniol on 9/7/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation

struct UserResult: Decodable, Equatable {
    var name: String
    var email: String
    var phone: String
    var pictures: [String : URL]
    
    init(name: String, email: String, phone: String, picture: [String : URL]) {
        self.name = name
        self.email = email
        self.phone = phone
        self.pictures = picture
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case phone
        case picture
        
        enum NameCodingKeys: String, CodingKey {
            case title
            case first
            case last
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let nameContainer = try container.nestedContainer(keyedBy: CodingKeys.NameCodingKeys.self, forKey: .name)
        let title = try nameContainer.decode(String.self, forKey: .title)
        let first = try nameContainer.decode(String.self, forKey: .first)
        let last = try nameContainer.decode(String.self, forKey: .last)
        self.name = "\(title) \(first) \(last)"
        
        self.email = try container.decode(String.self, forKey: .email)
        
        self.phone = try container.decode(String.self, forKey: .phone)
        
        let pictureContainer = try container.decode([String : String].self, forKey: .picture)
        var pictures: [String : URL] = [:]
        for (key, value) in pictureContainer {
            guard let url = URL(string: value) else { continue }
            pictures[key] = url
        }
        self.pictures = pictures
        
    }
}


struct UserResults: Decodable {
    let results: [UserResult]
}
