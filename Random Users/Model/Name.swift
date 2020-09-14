//
//  Name.swift
//  Random Users
//
//  Created by Shawn Gee on 4/10/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct Name: Decodable {
    let title: String
    let first: String
    let last: String
    
    var fullName: String {
        title + " " + first + " " + last
    }
}
