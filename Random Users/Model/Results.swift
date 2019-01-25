//
//  Results.swift
//  Random Users
//
//  Created by Benjamin Hakes on 1/25/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

//struct Results: Codable {
//    
//    // MARK: - Properties
//    
//    var results: [RandomUser]
//    
//    // Coding keys for encoding and decoding
//    enum CodingKeys: String, CodingKey {
//        case results
//        
//    }
//    
//    // MARK: - Initializers
//    init(results: [RandomUser]) {
//        self.results = results
//    }
//    
//    // MARK: - Codable
//    required init (from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        
//        // Decode the easy stuff
//        // Get the array of cover art url strings
//        var coverArtsContainer = try container.nestedUnkeyedContainer(forKey: .coverArtURLs)
//        var coverArtURLStrings: [String] = []
//        
//        // Cycle through them and pull them out of their objects, into the array
//        while !coverArtsContainer.isAtEnd {
//            let coverArtContainer = try coverArtsContainer.nestedContainer(keyedBy: CodingKeys.CoverArtCodingKeys.self)
//            let coverArtURLString = try coverArtContainer.decode(String.self, forKey: .url)
//            coverArtURLStrings.append(coverArtURLString)
//        }
//
//        
//        // Set all the properties
//        self.result = results
//    }
//    
//    // not sure if we'll need this
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        
//        // Encode the easy stuff
//        
//        try container.encode(name, forKey: .name)
//        try container.encode(email, forKey: .email)
//        try container.encode(picture, forKey: .picture)
//        try container.encode(phone, forKey: .phone)
//        
//    }
//}
