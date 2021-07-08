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
    var thumbnail: String
    
    // MARK: - Initializers
    init (large: String, medium: String, thumbnail: String, largeData: Data, mediumData: Data, thumbnailData: Data) {
        self.large = large
        self.medium = medium
        self.thumbnail = thumbnail
    }
    
}
