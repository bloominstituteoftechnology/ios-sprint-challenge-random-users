//
//  User.swift
//  Random Users
//
//  Created by Alex Shillingford on 1/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct User: Decodable {
    var title, first, last, email, cell: String
    var picture: UserImage
}
