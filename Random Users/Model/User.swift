//
//  User.swift
//  Random Users
//
//  Created by Nick Nguyen on 3/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct User : Decodable  {
    
    enum CodingKeys: String, CodingKey {
        case results
        
        enum ResultsCodingKeys: String, CodingKey {
            case name
            
            enum NameCodingKeys: String, CodingKey {
                case title
                case first
                case last
            }
            
            enum EmailCodingKeys: String,CodingKey {
                case email
            }
            enum PhoneCodingKeys: String,CodingKey {
                case phone
            }
            
            enum PicturesCodingKeys: String,CodingKey {
                case picture
                
                enum PictureCodingKeys: String, CodingKey {
                    case thumbnail
                    case large
                }
            }
        }
        
    }
    
    
    var name : String?
    var email: String?
    var phoneNumber : String?
    var picture : URL?
    var cellImage: URL?
    
    init(name: String, email: String , phoneNumber: String , picture: URL, cellImage: URL) {
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
        self.picture = picture
        self.cellImage = cellImage
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        var arrayContainer = try container.nestedUnkeyedContainer(forKey: CodingKeys.results)
        
        while  !arrayContainer.isAtEnd {
            let nameContainer = try arrayContainer.nestedContainer(keyedBy: CodingKeys.ResultsCodingKeys.NameCodingKeys.self)
            
            let title = try nameContainer.decode(String.self, forKey: .title)
            let firstName = try nameContainer.decode(String.self, forKey: .first)
            let lastName = try nameContainer.decode(String.self, forKey: .last)
            
            name = title + " " + firstName + " " + lastName
            
            let emailContainer = try arrayContainer.nestedContainer(keyedBy: CodingKeys.ResultsCodingKeys.EmailCodingKeys.self)
            
            email = try emailContainer.decode(String.self, forKey: .email)
            
            let phoneContainer = try arrayContainer.nestedContainer(keyedBy: CodingKeys.ResultsCodingKeys.PhoneCodingKeys.self)
            
            phoneNumber = try phoneContainer.decode(String.self, forKey: .phone)
            
            let picturesContainer = try arrayContainer.nestedContainer(keyedBy: CodingKeys.ResultsCodingKeys.PicturesCodingKeys.PictureCodingKeys.self)
            
            let pictureString = try picturesContainer.decode(String.self, forKey: .large)
            
            picture = URL(string: pictureString)
            
            let cellImageString = try picturesContainer.decode(String.self, forKey: .thumbnail)
            
            cellImage = URL(string: cellImageString)
        }
}
    
}
