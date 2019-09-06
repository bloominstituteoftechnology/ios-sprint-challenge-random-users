//
//  User.swift
//  RandomUsersSprint
//
//  Created by Luqmaan Khan on 9/6/19.
//  Copyright © 2019 Luqmaan Khan. All rights reserved.
//

import Foundation

struct Results: Decodable {
    var results: [User]
    enum ResultsKeys: String, CodingKey {
        case results
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ResultsKeys.self)
       results = try container.decode([User].self, forKey: .results)
    }
}


struct User: Decodable {
    var title: String
    var first: String
    var last: String
    var email: String
    var phone: String
    var large: URL
    var thumbnail: URL
    
    enum UserKeys: String, CodingKey {
        case title
        case name
        case first
        case last
        case email
        case phone
        case large
        case picture
        case thumbnail
        case results
    }
    enum NameKeys: String, CodingKey {
        case title
        case first
        case last
    }
    
    enum PictureKeys: String, CodingKey {
        case large
        case thumbnail
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UserKeys.self)
        let nameContainer = try container.nestedContainer(keyedBy: NameKeys.self, forKey: .name)
      title = try nameContainer.decode(String.self, forKey: .title)
        first = try nameContainer.decode(String.self, forKey: .first)
        last = try nameContainer.decode(String.self, forKey: .last)
       email = try container.decode(String.self, forKey: .email)
        phone = try container.decode(String.self, forKey: .phone)
        let pictureContainer = try container.nestedContainer(keyedBy: PictureKeys.self, forKey: .picture)
        large = try pictureContainer.decode(URL.self, forKey: .large)
        thumbnail = try pictureContainer.decode(URL.self, forKey: .thumbnail)
    }
    
}
