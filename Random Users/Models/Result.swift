//
//  Result.swift
//  Random Name
//
//  Created by Sammy Alvarado on 9/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct Result: Codable {
    let name: Name
    let email, phone: String
    let picture: Picture
}
