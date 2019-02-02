//
//  RandomUser.swift
//  Random Users
//
//  Created by Ivan Caldwell on 2/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation
struct RandomUser: Decodable {
    var title, first, last, email, phone: String
    var picture, thumbnail: URL
    
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case phone
        case picture
        
        enum Name: String, CodingKey {
            case title
            case first
            case last
        }
        
        enum Picture: String, CodingKey {
            case large
            case thumbnail
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Make a container for the nested Name Array
        let nameContainer = try container.nestedContainer(keyedBy: CodingKeys.Name.self, forKey: .name)
        first = try nameContainer.decode(String.self, forKey: .first)
        last = try nameContainer.decode(String.self, forKey: .last)
        title = try nameContainer.decode(String.self, forKey: .title)
        
        email = try container.decode(String.self, forKey: .email)
        phone = try container.decode(String.self, forKey: .phone)

        // Make a container for the nested Picture Array
        let pictureContainer = try container.nestedContainer(keyedBy: CodingKeys.Picture.self, forKey: .picture)
        picture = try pictureContainer.decode(URL.self, forKey: .large)
        thumbnail = try pictureContainer.decode(URL.self, forKey: .thumbnail)
    }
}

struct RandomUsers: Decodable {
    let results: [RandomUser]
}
