//
//  RandomUsersModel.swift
//  Random Users
//
//  Created by Sergey Osipyan on 2/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct RandomUsersModel: Codable {
    
    var results: [RandomUser]
}

struct RandomUser: Equatable {
    var title: String
    var first: String
    var last: String
    var phoneNumber: String
    var emailAddress: String
    var largeImageURL: URL?
    var thumbnailImageURL: URL?
}

extension RandomUser: Codable {
    
    enum ResultKeys: String, CodingKey {
        case name
        case phone
        case email
        case picture
        
        enum NameKeys: String, CodingKey {
            case first
            case last
            case title
        }
        
        enum PictureKeys: String, CodingKey {
            case thumbnail
            case large
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ResultKeys.self)
        let phone = try container.decode(String.self, forKey: .phone)
        let email = try container.decode(String.self, forKey: .email)
        let nameContainer = try container.nestedContainer(keyedBy: ResultKeys.NameKeys.self, forKey: .name)
        let first = try nameContainer.decode(String.self, forKey: .first)
        let last = try nameContainer.decode(String.self, forKey: .last)
        let title = try nameContainer.decode(String.self, forKey: .title)
        
        
        let pictureContainer = try container.nestedContainer(keyedBy: ResultKeys.PictureKeys.self, forKey: .picture)
        let thumbnailImage = try pictureContainer.decode(String.self, forKey: .thumbnail)
        let largeImage = try pictureContainer.decode(String.self, forKey: .large)
        
        let thumbnailImageURL = URL(string: thumbnailImage)
        let largeImageURL = URL(string: largeImage)
        
        self.first = first
        self.last = last
        self.title = title
        self.phoneNumber = phone
        self.emailAddress = email
        self.thumbnailImageURL = thumbnailImageURL
        self.largeImageURL = largeImageURL
    }
}
