//
//  Users.swift
//  ContactManager
//
//  Created by Farhan on 10/12/18.
//  Copyright © 2018 Farhan. All rights reserved.
//

import Foundation

struct Users: Decodable {
    
    // MARK:- Properties
    
    var users: [User] = []
    
    // MARK:- Coding Keys
    
    enum UserCodingKeys: String, CodingKey {
        case results
    }
    
    enum ResultCodingKeys: String, CodingKey {
        case name
        case email
        case phone
        case picture
    }
    
    enum NameCodingKeys: String, CodingKey {
        case title
        case first
        case last
    }
    
    enum PictureCodingKeys: String, CodingKey {
        case thumbnail
        case large
    }
    
    // MARK:- Decoder
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: UserCodingKeys.self)
        var resultsContainer = try container.nestedUnkeyedContainer(forKey: .results)
        
        while !resultsContainer.isAtEnd{
            let userContainer = try resultsContainer.nestedContainer(keyedBy: ResultCodingKeys.self)
            
            let email = try userContainer.decode(String.self, forKey: .email)
            let phone = try userContainer.decode(String.self, forKey: .phone)
            
            let nameContainer = try userContainer.nestedContainer(keyedBy: NameCodingKeys.self, forKey: .name)
            
            let title = try nameContainer.decode(String.self, forKey: .title)
            let firstName = try nameContainer.decode(String.self, forKey: .first)
            let lastName = try nameContainer.decode(String.self, forKey: .last)
            let name = "\(title) \(firstName) \(lastName)"
            
            let pictureContainer = try userContainer.nestedContainer(keyedBy: PictureCodingKeys.self, forKey: .picture)
            
            let largeURL = try pictureContainer.decode(String.self, forKey: .large)
            let thumbnailURL = try pictureContainer.decode(String.self, forKey: .thumbnail)
            
            let user = User(name: name, phone: phone, email: email, imageThumbnailURL: URL(string: largeURL)!, imageLargeURL: URL(string: thumbnailURL)!)
            
            users.append(user)
            
        }
        
    }
    
    struct User: Decodable {
        
        // MARK:- Properties
        
        var name: String
        var phone: String
        var email: String
        var imageThumbnailURL: URL
        var imageLargeURL: URL
        
    }
}
