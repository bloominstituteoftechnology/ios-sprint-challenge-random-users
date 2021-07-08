//
//  Coordinates.swift
//  Random Users
//
//  Created by Benjamin Hakes on 1/26/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct Coordinates: Codable {
    
    // MARK: - Properties
    var latitude: String
    var longitude: String
    
    // MARK: - Initializers
    init (latitude: String, longitude: String) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
}
