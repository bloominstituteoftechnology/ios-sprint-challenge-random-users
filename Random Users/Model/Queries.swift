//
//  Queries.swift
//  Random Users
//
//  Created by Lambda_School_loaner_226 on 7/20/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct Queries: Codable {
    struct Info: Codable {
        let seed: String
        let results: Int
        let page: Int
        let version: String
    }
    let results: [User]
    let info: Info
}
