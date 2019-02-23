//
//  User.swift
//  Random Users
//
//  Created by Jocelyn Stuart on 2/22/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

/*struct Results: Decodable {
    
 
    var re
    
}*/

struct User: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case results
        enum ResultsCodingKeys: String, CodingKey {
            case name
            enum NameCodingKeys: String, CodingKey {
                case first
                case last
            }
            case email
            case phone
            case picture
            enum PictureCodingKeys: String, CodingKey {
                case large
                case thumbnail
            }
        }
    }
    
    
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
    
        var resultsContainer = try container.nestedUnkeyedContainer(forKey: .results)
    
        var email: String = ""
        var phone: String = ""
        var name: [String: String] = [:]
        var picture: [String: String] = [:]
        var largePic: String = ""
        var thumbnail: String = ""
        var firstName: String = ""
        var lastName: String = ""
        var fullName: String = ""
        
        
        while !resultsContainer.isAtEnd {
            
            let resultContainer = try resultsContainer.nestedContainer(keyedBy: CodingKeys.ResultsCodingKeys.self)
            
            email = try resultContainer.decode(String.self, forKey: .email)
            phone = try resultContainer.decode(String.self, forKey: .phone)
            
            let nameContainer = try resultContainer.nestedContainer(keyedBy: CodingKeys.ResultsCodingKeys.NameCodingKeys.self, forKey: .name)
            firstName = try nameContainer.decode(String.self, forKey: .first)
            lastName = try nameContainer.decode(String.self, forKey: .last)
            
            name["first"] = firstName
            name["last"] = lastName
            
            fullName = firstName + "" + lastName
            
            let pictureContainer = try resultContainer.nestedContainer(keyedBy: CodingKeys.ResultsCodingKeys.PictureCodingKeys.self, forKey: .picture)
            
            thumbnail = try pictureContainer.decode(String.self, forKey: .thumbnail)
            largePic = try pictureContainer.decode(String.self, forKey: .large)
            
            picture["thumbnail"] = thumbnail
            picture["large"] = largePic
            
        }
        

        
        self.results = [[name, email, phone, picture]]
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phone = phone
        self.name = name
        self.largePic = largePic
        self.thumbnail = thumbnail
        self.picture = picture
        self.fullName = fullName
        
    }
    
    let results: [[Any]]
    
    let name: [String: String] // like species, -ability
    let email: String
    let phone: String
    let firstName: String?
    let lastName: String?
    
    let picture: [String: String] // like species
    let largePic: String?
    let thumbnail: String?
    let fullName: String?
    
    
    /*func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        var resultsContainer = container.nestedUnkeyedContainer(forKey: .results)
        
        var resultContainer = resultsContainer.nestedContainer(keyedBy: CodingKeys.ResultsCodingKeys.self)
        
        try resultContainer.encode(email, forKey: .email)
        try resultContainer.encode(phone, forKey: .phone)
        
        for _ in results {
            var nameContainer = resultContainer.nestedContainer(keyedBy: CodingKeys.ResultsCodingKeys.NameCodingKeys.self, forKey: .name)
            
            var pictureContainer = resultContainer.nestedContainer(keyedBy: CodingKeys.ResultsCodingKeys.PictureCodingKeys.self, forKey: .picture)
            
            try nameContainer.encode(firstName, forKey: .first)
            try nameContainer.encode(lastName, forKey: .last)
            try pictureContainer.encode(largePic, forKey: .large)
            try pictureContainer.encode(thumbnail, forKey: .thumbnail)
        }
        
        
    }*/
    
}
    
    
    
    
    
    
    

