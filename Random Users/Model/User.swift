//
//  User.swift
//  Random Users
//
//  Created by Carolyn Lea on 9/7/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

struct Name: Decodable
{
    var title: String?
    var firstName: String?
    var lastName: String?
    
    init(title: String, firstName: String, lastName: String)
    {
        self.title = title
        self.firstName = firstName
        self.lastName = lastName
    }
    
    enum NameCodingKeys: String, CodingKey
    {
        case title
        case first
        case last
    }
    
    init(from decoder: Decoder) throws
    {
        let nameContainer = try decoder.container(keyedBy: NameCodingKeys.self)
        
        let title = try nameContainer.decode(String.self, forKey: .title)
        let firstName = try nameContainer.decode(String.self, forKey: .first)
        let lastName = try nameContainer.decode(String.self, forKey: .last)
        
        self.title = title
        self.firstName = firstName
        self.lastName = lastName
    }
}

struct Picture: Decodable
{
    let large: URL?
    let medium: URL?
    let thumbnail: URL?
    
    enum PictureCodingKeys: String, CodingKey
    {
        case large
        case medium
        case thumbnail
    }
    
    init(from decoder: Decoder) throws
    {
        let pictureContainer = try decoder.container(keyedBy: PictureCodingKeys.self)
        let largeString = try pictureContainer.decode(String.self, forKey: .large)
        let mediumString = try pictureContainer.decode(String.self, forKey: .medium)
        let thumbnailString = try pictureContainer.decode(String.self, forKey: .thumbnail)
        
        var large: URL?
        let lString = largeString
        large = URL(string: lString)
        
        var medium: URL?
        let mString = mediumString
        medium = URL(string: mString)
        
        var thumbnail: URL?
        let tString = thumbnailString
        thumbnail = URL(string: tString)
        
        self.large = large
        self.medium = medium
        self.thumbnail = thumbnail
    }
}

struct User: Decodable
{
    var name: Name?
    var email: String?
    var phone: String?
    var picture: Picture?
    var identifier: String = UUID().uuidString
    
    enum CodingKeys: String, CodingKey
    {
        case name
        case email
        case phone
        case picture
        
    }
    
    init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let name = try container.decode(Name.self, forKey: .name)
        
        let email = try container.decode(String.self, forKey: .email)
        
        let phone = try container.decode(String.self, forKey: .phone)
        
        let picture = try container.decode(Picture.self, forKey: .picture)
        
        self.name = name
        self.email = email
        self.phone = phone
        self.picture = picture
    }
}

struct Users: Decodable
{
    let results: [User]?
    
    enum CodingKeys: String, CodingKey
    {
        case results
    }
    
    init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        results = try container.decode([User].self, forKey: .results)
        
    }
}

