//
//  UserPhoto.swift
//  Random Users
//
//  Created by Juan M Mariscal on 5/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct UserPhoto: Codable, Equatable {
    let thumbnailImageURL: URL
    let mediumImageURL: URL
    let id: Int
    
    enum CodingKeys: String, CodingKey {
        case thumbnailImageURL = "https://randomuser.me/api/portraits/thumb/men/75.jpg"
        case mediumImageURL = "https://randomuser.me/api/portraits/med/men/75.jpg"
        case id
    }
}
