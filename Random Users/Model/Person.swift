//
//  Person.swift
//  Random Users
//
//  Created by Angel Buenrostro on 3/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct Person: Decodable {
    
    enum CodingKeys: String, CodingKey {
        
        case name
        case picture
        case phone
        case email
        case login
        
        enum NameKeys: String, CodingKey {
            case title
            case first
            case last
        }
        
        enum PictureKeys: String, CodingKey {
            case large
            case thumbnail
        }
        
        enum LoginKeys: String, CodingKey {
            case uuid
        }
        
    }
    
    
    var name: String
    var picture: [String : URL]
    var phone: String
    var email: String
    var login: UUID
    
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let nameContainer = try container.nestedContainer(keyedBy: CodingKeys.NameKeys.self, forKey: .name)
        let title = try nameContainer.decode(String.self, forKey: .title)
        let firstName = try nameContainer.decode(String.self, forKey: .first)
        let lastName = try nameContainer.decode(String.self, forKey: .last)
        
        let pictureContainer = try container.nestedContainer(keyedBy: CodingKeys.PictureKeys.self, forKey: .picture)
        let large = try pictureContainer.decode(String.self, forKey: .large)
        let thumbnail = try pictureContainer.decode(String.self, forKey: .thumbnail)
        
        let largeURL = URL(string: large)!
        let thumbnailURL = URL(string: thumbnail)!
        
        let pictureDictionary = ["large": largeURL, "thumbnail" : thumbnailURL]
        
        let phone = try container.decode(String.self, forKey: .phone)
        let email = try container.decode(String.self, forKey: .email)
        
        let loginContainer = try container.nestedContainer(keyedBy: CodingKeys.LoginKeys.self, forKey: .login)
        let uuid = try loginContainer.decode(String.self, forKey: .uuid)
        let personUUID = UUID(uuidString: uuid)!
        
        
        self.name = ("\(title). \(firstName) \(lastName)")
        self.picture = pictureDictionary
        self.phone = phone
        self.email = email
        self.login = personUUID
    }
}
