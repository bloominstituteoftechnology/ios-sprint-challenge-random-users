//
//  Picture.swift
//  Random Users
//
//  Created by Benjamin Hakes on 1/25/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import Foundation

struct Picture: Codable {
    
    // MARK: - Properties
    var large: String
    var medium: String
    var small: String
    
    // Coding keys for encoding and decoding
    enum CodingKeys: String, CodingKey {
        case large
        case medium
        case small
        
    }
    
    // MARK: - Initializers
    init (large: String, medium: String, small: String) {
        self.large = large
        self.medium = medium
        self.small = small
    }
    
    // MARK: - Codable
    init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode the easy stuff
        let large = try container.decode(String.self, forKey: .large)
        let medium = try container.decode(String.self, forKey: .medium)
        let small = try container.decode(String.self, forKey: .small)
        
        // Set the properties
        self.large = large
        self.medium = medium
        self.small = small
    }
    
    // Not sure we're going to need this
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        // Encode the easy stuff
        try container.encode(large, forKey: .large)
        try container.encode(medium, forKey: .medium)
        try container.encode(small, forKey: .small)
        
    }
}
