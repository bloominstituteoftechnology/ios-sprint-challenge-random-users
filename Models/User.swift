//
//  User.swift
//  Random Users
//
//  Created by macbook on 11/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct Results: Codable {
    let results: [User]
}

struct User: Codable {
    
    //    var results: [UserResult]
    
    //    struct UserResult: Codable {
    
    var name: UserName
    var email: String
    var phone: String
    var picture: ImageSize
 
    enum UserKeys: String, CodingKey {
        case name
        case email
        case phone
        case picture
        
    }
}
    
    struct UserName: Codable {
        var title: String
        var first: String
        var last: String
        
        enum NameKeys: String, CodingKey {
            case title
            case first
            case last
        }
    }
    
    
    struct ImageSize: Codable {
        var large: URL
        var thumbnail: URL
        
        enum ImageSizeKeys: String, CodingKey {
            case large
            case thumbnail
        }
    }
    //    }



