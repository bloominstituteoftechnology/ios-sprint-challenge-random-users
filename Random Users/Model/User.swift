//
//  User.swift
//  Random Users
//
//  Created by Moses Robinson on 2/22/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

struct User: Codable {
    
    let name: String
    let email: String
    let phone: String
    let imageURL: URL
    let largeImageURL: URL
    
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case phone
        case imageURL = "picture"
        case largeImageURL
        
        enum NameCodingKeys: String, CodingKey {
            case title
            case first
            case last
        }
        
        enum PictureCodingKeys: String, CodingKey {
            case large
            case thumbnail
        }
    }
    
    // MARK: - DECODER
    
    
    
    // MARK: - ENCODER
    
    
    
    init(name: String, email: String, phone: String, imageURL: URL, largeImageURL: URL) {
        (self.name, self.email, self.phone, self.imageURL, self.largeImageURL) = (name, email, phone, imageURL, largeImageURL)
    }
}
