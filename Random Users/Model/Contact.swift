//
//  Contact.swift
//  Random Users
//
//  Created by Dillon McElhinney on 10/12/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation

struct Contact: Decodable {
    
    // MARK: - Properties
    let title: String
    let firstName: String
    let lastName: String
    let email: String
    let phoneNumbers: [String]
    let thumbnailURL: URL?
    let imageURL: URL?
    let id: String
    
    var name: String {
        return "\(title.capitalized) \(firstName.capitalized) \(lastName.capitalized)"
    }
    
    // Coding keys used for decoding and encoding
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case phone
        case cell
        case picture
        case login
        
        enum NameCodingKeys: String, CodingKey {
            case title
            case first
            case last
        }
        
        enum PictureCodingKeys: String, CodingKey {
            case large
            case thumbnail
        }
        
        enum LoginCodingKeys: String, CodingKey {
            case uuid
        }
    }
    
    // MARK: - Decodable
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let email = try container.decode(String.self, forKey: .email)
        let phone = try container.decodeIfPresent(String.self, forKey: .phone)
        let cell = try container.decodeIfPresent(String.self, forKey: .cell)
        var phoneNumbers: [String] = []
        if let phone = phone { phoneNumbers.append(phone) }
        if let cell = cell { phoneNumbers.append(cell) }
        
        let nameContainer = try container.nestedContainer(keyedBy: CodingKeys.NameCodingKeys.self, forKey: .name)
        let title = try nameContainer.decode(String.self, forKey: .title)
        let firstName = try nameContainer.decode(String.self, forKey: .first)
        let lastName = try nameContainer.decode(String.self, forKey: .last)
        
        let pictureContainer = try container.nestedContainer(keyedBy: CodingKeys.PictureCodingKeys.self, forKey: .picture)
        let thumbnailURLString = try pictureContainer.decode(String.self, forKey: .thumbnail)
        let thumbnailURL = URL(string: thumbnailURLString)
        
        let imageURLString = try pictureContainer.decode(String.self, forKey: .large)
        let imageURL = URL(string: imageURLString)
        
        let loginContainer = try container.nestedContainer(keyedBy: CodingKeys.LoginCodingKeys.self, forKey: .login)
        let id = try loginContainer.decode(String.self, forKey: .uuid)
        
        self.title = title
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phoneNumbers = phoneNumbers
        self.thumbnailURL = thumbnailURL
        self.imageURL = imageURL
        self.id = id
    }
}

// Convience struct for holding the top-level result from the JSON
struct ContactResults: Decodable {
    let results: [Contact]
}
