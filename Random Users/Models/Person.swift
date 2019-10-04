//
//  Person.swift
//  Random Users
//
//  Created by Alex Rhodes on 10/4/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct People: Codable {
    let results: [Person]
    
    enum PeopleKeys: String, CodingKey {
        case results
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: PeopleKeys.self)
        
        let results = try container.decode([Person].self, forKey: .results)
        
        self.results = results
    }

}

struct Person: Codable {
    let name: Name
    let email: String
    let phone: String
    let picture: Picture
    
    enum PersonKeys: String, CodingKey {
        case name
        case email
        case phone
        case picture
        
    }
//
//    required init(from decoder: Decoder) throws {
//
//        let container = try decoder.container(keyedBy: PersonKeys.self)
//        var nameContainer = try container.nestedUnkeyedContainer(forKey: .name)
//        var pictureContainer = try container.nestedUnkeyedContainer(forKey: .picture)
//
//        email = try container.decode(String.self, forKey: .email)
//        phone = try container.decode(String.self, forKey: .phone)
//        name = try nameContainer.decode(Name.self)
//        picture = try pictureContainer.decode(Picture.self)

//    }
    
    static var jsonDecoder: JSONDecoder {
        let result = JSONDecoder()
        return result
    }
}

class Name: Codable {
    let title: String
    let first: String
    let last: String
    
    enum NameKeys: String, CodingKey {
        case title
        case first
        case last
    }
    
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: NameKeys.self)
//
//        title = try container.decode(String.self, forKey: .title)
//        first = try container.decode(String.self, forKey: .first)
//        last = try container.decode(String.self, forKey: .last)
//    }
}

class Picture: Codable {
    let large: URL
    let medium: URL
    let thumbnail: URL
    
    enum PictureKeys: String, CodingKey {
        case large
        case medium
        case thumbnail
    }
    
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: PictureKeys.self)
//        
//        large = try container.decode(URL.self, forKey: .large)
//        medium = try container.decode(URL.self, forKey: .medium)
//        thumbnail = try container.decode(URL.self, forKey: .thumbnail)
//        
//    }
}
