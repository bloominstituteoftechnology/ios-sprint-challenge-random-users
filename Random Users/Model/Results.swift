//
//  Results.swift
//  Random Users
//
//  Created by Bradley Yin on 9/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct Results: Decodable {
    var results: [User]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        results = try container.decode([User].self, forKey: .results)
    }
}
