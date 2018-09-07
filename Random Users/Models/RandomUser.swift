//
//  RandomUser.swift
//  Random Users
//
//  Created by Lisa Sampson on 9/7/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

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
