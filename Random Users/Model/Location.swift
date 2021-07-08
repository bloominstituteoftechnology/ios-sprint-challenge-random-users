//
//  Location.swift
//  Random Users
//
//  Created by Benjamin Hakes on 1/26/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class Location: Codable {
    
    // MARK: - Properties
    var coordinates: Coordinates
    
    // Coding keys for encoding and decoding
    enum CodingKeys: String, CodingKey {
        case coordinates
        
    }
    
    // MARK: - Initializers
    init (coordinates: Coordinates) {
        self.coordinates = coordinates
    }
    
    // MARK: - Codable
    required init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode the easy stuff
        let coordinates = try container.decode(Coordinates.self, forKey: .coordinates)
        
        // Set all the properties
        self.coordinates = coordinates
    }
    
    
}
