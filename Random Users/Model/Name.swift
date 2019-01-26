//
//  Name.swift
//  Random Users
//
//  Created by Benjamin Hakes on 1/25/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import Foundation

struct Name: Codable {
    
    // MARK: - Properties
    var title: String
    var first: String
    var last: String

    // MARK: - Initializers
    init (title: String, first: String, last: String) {
        self.title = title
        self.first = first
        self.last = last
    }

}
