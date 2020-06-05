//
//  Names.swift
//  Random Users
//
//  Created by Joe Veverka on 6/5/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct Names: Decodable {
    let title: String
    let first: String
    let last: String

    var fullName: String {
        title + " " + first + " " + last
    }
}
