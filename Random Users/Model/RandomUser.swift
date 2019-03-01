//
//  RandomUser.swift
//  Random Users
//
//  Created by Paul Yi on 3/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct RandomUsers: Decodable {
    enum CodingKeys: String, CodingKey {
        case randomUsers = "results"
    }
    
    var randomUsers: [RandomUser]
}

struct RandomUser: Equatable {
    var name: String
    var phoneNumber: String?
    var emailAddress: String?
    var largeImageURL: URL?
    var thumbnailImageURL: URL?
}
