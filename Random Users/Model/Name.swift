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
    
    // Coding keys for encoding and decoding
    enum CodingKeys: String, CodingKey {
        case title
        case first
        case last
        
    }
    
    // MARK: - Initializers
    init (title: String, first: String, last: String) {
        self.title = title
        self.first = first
        self.last = last
    }
    
    // MARK: - Codable
    init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode the easy stuff
        let title = try container.decode(String.self, forKey: .title)
        let first = try container.decode(String.self, forKey: .first)
        let last = try container.decode(String.self, forKey: .last)
        
        // Set the properties
        self.title = title
        self.first = first
        self.last = last
    }
    
    // Not sure we're going to need this
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        // Encode the easy stuff
        try container.encode(title, forKey: .title)
        try container.encode(first, forKey: .first)
        try container.encode(last, forKey: .last)
        
    }
}
