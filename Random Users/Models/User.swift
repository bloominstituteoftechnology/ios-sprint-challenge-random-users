//
//  User.swift
//  Random Users
//
//  Created by Michael Flowers on 6/21/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation
struct User: Codable {
    //these properties can be whatever name I want to give them
    let title: String
    let firstName: String
    let lastName: String
    let email: String
    let phone: String
    let largePhoto: URL //convert from string on json to type url
    let thumbnail: URL //convert from string on json to url on swift
    let fullName: String
    enum UserKeys: String, CodingKey {
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
        let container = try decoder.container(keyedBy: UserKeys.self)
        email = try container.decode(String.self, forKey: .email)
        phone = try container.decode(String.self, forKey: .phone)
        
        //assign value to the name properties
        let nameContainerDictionary = try container.nestedContainer(keyedBy: UserKeys.NameKeys.self, forKey: .name)
        title = try nameContainerDictionary.decode(String.self, forKey: .title)
        firstName = try nameContainerDictionary.decode(String.self, forKey: .first)
        lastName = try nameContainerDictionary.decode(String.self, forKey: .last)
        
        //assign value to the photo properties
        let photoDictionaryContainer = try container.nestedContainer(keyedBy: UserKeys.PictureKeys.self, forKey: .picture)
        largePhoto = try photoDictionaryContainer.decode(URL.self, forKey: .large)
        thumbnail = try photoDictionaryContainer.decode(URL.self, forKey: .thumbnail)
        fullName = "\(title) \(firstName) \(lastName)"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: UserKeys.self)
        //top level
        try container.encode(email, forKey: .email)
        try container.encode(phone, forKey: .phone)
        
        //get inside of the name dictionary
        var nameDictionaryContainer = container.nestedContainer(keyedBy: UserKeys.NameKeys.self, forKey: .name)
        try nameDictionaryContainer.encode(title, forKey: .title)
        try nameDictionaryContainer.encode(firstName, forKey: .first)
        try nameDictionaryContainer.encode(lastName, forKey: .last)
        
        //get inside of the picture dictionary
        var pictureDictionaryContainer = container.nestedContainer(keyedBy: UserKeys.PictureKeys.self, forKey: .picture)
        try pictureDictionaryContainer.encode(largePhoto, forKey: .large)
        try pictureDictionaryContainer.encode(thumbnail, forKey: .thumbnail)
    }
}
