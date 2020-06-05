//
//  Images.swift
//  Random Users
//
//  Created by Joe Veverka on 6/5/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct Images: Decodable {
    let large: URL
    let medium: URL
    let thumbnail: URL
}
