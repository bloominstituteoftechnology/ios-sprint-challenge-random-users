//
//  Face.swift
//  Random Users
//
//  Created by Bradley Diroff on 4/10/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct Results: Codable {
    var results: [Face]
    
    enum ResultsKeys: String, CodingKey {
        case results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ResultsKeys.self)
        
        results = try container.decode([Face].self, forKey: .results)
    }
    
}

struct Face: Codable {
    
    var id: Int
    var name: String
    var phone: String
    var email: String
    var picture: String
    var thumbnail: String
    
    enum FaceKeys: String, CodingKey {
        case name
        case email
        case phone
        case picture
        
        enum NameKeys: String, CodingKey {
            case title
            case first
            case last
        }
        
        enum PictureKeys: String, CodingKey {
            case large
            case thumbnail
        }
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: FaceKeys.self)
        
        let nameContainer = try container.nestedContainer(keyedBy: FaceKeys.NameKeys.self, forKey: .name)
        let first = try nameContainer.decode(String.self, forKey: .first)
        let last = try nameContainer.decode(String.self, forKey: .last)
        name = "\(first) \(last)"
        
        phone = try container.decode(String.self, forKey: .phone)
        email = try container.decode(String.self, forKey: .email)
        
        let picContainer = try container.nestedContainer(keyedBy: FaceKeys.PictureKeys.self, forKey: .picture)
        picture = try picContainer.decode(String.self, forKey: .large)
        thumbnail = try picContainer.decode(String.self, forKey: .thumbnail)
        
        id = 0
    }
    
}
    
