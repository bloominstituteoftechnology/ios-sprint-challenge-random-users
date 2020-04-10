//
//  Picture.swift
//  Random Users
//
//  Created by Shawn Gee on 4/10/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct Picture: Decodable {
    let large: URL
    let medium: URL
    let thumbnail: URL
}
