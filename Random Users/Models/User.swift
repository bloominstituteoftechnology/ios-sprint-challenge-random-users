//
//  User.swift
//  Random Users
//
//  Created by David Wright on 3/22/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

enum PictureType: String, CaseIterable { case large, medium, thumbnail } //static var allValues = { PictureType.allCases.map { $0.rawValue } }()
//enum NameType: String { case title, first, last }

struct User {
    
    // MARK: - Properties
    
    var name: String
    var email: String
    var phone: String
    var picture: Picture
    
    // MARK: - Coding Keys
    
    enum CodingKeys: String, CodingKey {
        case results
        
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
                case medium
                case thumbnail
            }
        }
    }
}

extension User: Decodable {
    
    // MARK: - Decoder

        init(from decoder: Decoder) throws {

            // { full json }
            let container = try decoder.container(keyedBy: CodingKeys.self)
            var resultsContainer = try container.nestedUnkeyedContainer(forKey: .results)
            let userContainer = try resultsContainer.nestedContainer(keyedBy: CodingKeys.UserKeys.self)
            
            // Decode 'email' and 'phone'
            self.email = try userContainer.decode(String.self, forKey: .email)
            self.phone = try userContainer.decode(String.self, forKey: .phone)
            
            // Decode 'name'
            let nameDictionary = try userContainer.decode([String: String].self, forKey: .name)
            var name: String = ""
            
            if let title = nameDictionary["title"] { name += "\(title) " }
            if let first = nameDictionary["first"] { name += "\(first) " }
            if let last = nameDictionary["last"] { name += "\(last) " }
            self.name = name
            
            // Decode 'picture'
            self.picture = try userContainer.decode(Picture.self, forKey: .picture)
            
//            let pictureDictionary = try userContainer.decode([String: URL].self, forKey: .picture)
//            var picture: [PictureType: String] = [:]
//
//            for key in pictureDictionary.keys {
//                if let pictureType = PictureType(rawValue: key) {
//                    picture[pictureType] = pictureDictionary[key]
//                }
//            }
//            self.picture = picture
    }
}

// Encodable implementation is not required for MVP
/*
extension User: Encodable {
    
}
*/

struct Picture: Decodable {
    var large: URL
    var medium: URL
    var thumbnail: URL
}
