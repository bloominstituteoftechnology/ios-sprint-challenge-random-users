//
//  RandomUser.swift
//  Random Users
//
//  Created by Sameera Roussi on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct RandomUser: Equatable, Decodable {
    var name: String?
    var phoneNumber: String?
    var email: String?
    var thumbNailURL: URL?
    var largeImageURL: URL?
    
    enum UserImages: String {
        case thumbnail
        case large
    }
    
    enum UserKeys: String, CodingKey {
        case name
        case phoneNumber = "phone"
        case email
        case imagesURL = "picture"
    }
    
    enum UserNameKeys: String, CodingKey {
        case title
        case first
        case last
    }
    
    enum ImageURLKeys: String, CodingKey {
        case thumbnail
        case large
    }
}
