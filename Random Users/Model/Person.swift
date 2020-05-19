//
//  Person.swift
//  Random Users
//
//  Created by Marc Jacques on 5/17/20.
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
}
