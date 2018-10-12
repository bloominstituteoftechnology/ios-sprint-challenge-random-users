//
//  User.swift
//  Random Users
//
//  Created by Madison Waters on 10/12/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation

struct User: Decodable {
    
    var firstName: String = "First Name"
    var lastName: String = "Last Name"
    var largePicURL: [URL]
    var thumbPicURL: [URL]
    
    init(firstName: String, lastName: String, largePicURL: [URL], thumbPicURL: [URL]) {
        self.firstName = firstName
        self.lastName = lastName
        self.largePicURL = largePicURL
        self.thumbPicURL = thumbPicURL
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        //case id
        case picture
        
        enum NameCodingKeys: String, CodingKey {
            case first
            case last
        }
        
//        enum IdCodingKeys: String, CodingKey {
//            case value
//        }
        
        enum PictureCodingKeys: String, CodingKey {
            case large
            case thumbnail
        }
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let nameContainer = try container.nestedContainer(keyedBy: CodingKeys.NameCodingKeys.self, forKey: .name)
        
        let firstName = try nameContainer.decode(String.self, forKey: .first)
        
        let lastName = try nameContainer.decode(String.self, forKey: .last)
        
        let pictureContainer = try container.nestedContainer(keyedBy: CodingKeys.PictureCodingKeys.self, forKey: .picture)
        
        let largePic = try pictureContainer.decode(String.self, forKey: .large)
        
        let thumbPic = try pictureContainer.decode(String.self, forKey: .thumbnail)
    
        let largePicURL = largePic.compactMap() { _ in URL(string: largePic) }
        let thumbPicURL = thumbPic.compactMap() { _ in URL(string: thumbPic) }
        
        self.firstName = firstName
        self.lastName = lastName
        self.largePicURL = largePicURL
        self.thumbPicURL = thumbPicURL
        
    }
    
}
//}

///////// Try this if the other doesn't work ////////////
//    init(from decoder: Decoder) throws {
//
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        var nameContainer = try container.nestedUnkeyedContainer(forKey: .name)
//
//        var name: [String] = []
//
//        while !nameContainer.isAtEnd {
//            let fullNameContainer = try nameContainer.nestedContainer(keyedBy: CodingKeys.NameCodingKeys.self)
//
//            let firstNameContainer = try fullNameContainer.nestedContainer(keyedBy: CodingKeys, forKey: <#T##User.CodingKeys.NameCodingKeys#>)
//        }
//
//    }


