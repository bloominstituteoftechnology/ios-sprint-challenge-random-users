//
//  User.swift
//  Random Users
//
//  Created by Scott Bennett on 10/12/18.
//  Copyright © 2018 Scott Bennett. All rights reserved.
//

import UIKit

struct User: Codable {
    var name: String
    var email: String
    var phone: String
    var largeImage: URL!
    var thumbImage: URL!
    
    init() {
        name = ""
        email = ""
        phone = ""
        largeImage = nil
        thumbImage = nil
    }
    
    struct Results: Codable {
        var results: [User]
    }
    
    enum TopCodingKeys: String, CodingKey {
        case name
        case email
        case phone
        case picture
    }
    
    enum NameKeys: String, CodingKey {
        case title
        case first
        case last
    }
    
    enum PhotoKeys: String, CodingKey {
        case large
        case medium
        case thumbnail
    }
    
    init(from decoder: Decoder) throws {
        
        let containter = try decoder.container(keyedBy: TopCodingKeys.self)
        name = ""
        email = try containter.decode(String.self, forKey: .email)
        phone = try containter.decode(String.self, forKey: .phone)
        
        let nameContainer = try containter.nestedContainer(keyedBy: NameKeys.self, forKey: .name)
        let title = try nameContainer.decode(String.self, forKey: .title).capitalized
        let first = try nameContainer.decode(String.self, forKey: .first).capitalized
        let last = try nameContainer.decode(String.self, forKey: .last).capitalized
        name = "\(title) \(first) \(last)"
        
        let photoContainer = try containter.nestedContainer(keyedBy: PhotoKeys.self, forKey: .picture)
        largeImage = try photoContainer.decode(URL.self, forKey: .large)
        thumbImage = try photoContainer.decode(URL.self, forKey: .thumbnail)
    }
}


