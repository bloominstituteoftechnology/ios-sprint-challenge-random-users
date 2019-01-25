//
//  Results.swift
//  Random Users
//
//  Created by Benjamin Hakes on 1/25/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct Results: Codable {
    
    // MARK: - Properties
    
    var results: [RandomUser]
    
    // Coding keys for encoding and decoding
    enum CodingKeys: String, CodingKey {
        case results
        
    }
    
    // MARK: - Initializers
    init(results: [RandomUser]) {
        self.results = results
    }
    
    static var jsonDecoder: JSONDecoder {
        return JSONDecoder()
    }
}
