//
//  RandomUser.swift
//  Random Users
//
//  Created by Paul Yi on 3/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct RandomUser: Equatable {
    var name: String
    var phoneNumber: String?
    var emailAddress: String?
    var largeImageURL: URL?
    var thumbnailImageURL: URL?
}
