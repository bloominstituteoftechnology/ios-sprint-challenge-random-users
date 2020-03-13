//
//  User.swift
//  Random Users
//
//  Created by Chris Gonzales on 3/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

class Users: Decodable {
    var results: [User] = []
    
    enum ResultsKeys: String, CodingKey {
        case results
    }
    
    required init(from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: ResultsKeys.self)
        self.results = try container.decode([User].self, forKey: .results)
    }
}

class User: Decodable {
    
    // MARK: - Properties
    
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    
    var first: String
    var last: String
    var thumbnail: String
    var largePhoto: String
    var phoneNumber: String
    var emailAddress: String
    
    enum UserKeys: String, CodingKey {
        case name
        case picture
        case email
        case phone
        
        enum NameKeys: String, CodingKey {
            case first
            case last
        }
        enum PictureKeys: String, CodingKey {
            case large
            case thumbnail
        }
    }
    
    // MARK: - Initializers
    
    init(firstName: String, lastName: String,
         email: String, phoneNumber: String, thumbnail: String, largePhoto: String) {
        self.first = firstName
        self.last = lastName
        self.emailAddress = email
        self.phoneNumber = phoneNumber
        self.thumbnail = thumbnail
        self.largePhoto = largePhoto
    }
    
    enum ResultsKey: String, CodingKey {
        case results
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: UserKeys.self)
        
        self.emailAddress = try container.decode(String.self,
                                                 forKey: .email)
        self.phoneNumber = try container.decode(String.self,
                                                forKey: .phone)
        
        let nameContatiner = try container.nestedContainer(keyedBy: UserKeys.NameKeys.self, forKey: .name)
        self.first = try nameContatiner.decode(String.self,
                                               forKey: .first)
        self.last = try nameContatiner.decode(String.self,
                                              forKey: .last)
        
        let pictureContainer = try container.nestedContainer(keyedBy: UserKeys.PictureKeys.self, forKey: .picture)
        self.thumbnail = try pictureContainer.decode(String.self,
                                                     forKey: .thumbnail)
        self.largePhoto = try pictureContainer.decode(String.self,
                                                      forKey: .large)
    }
}
