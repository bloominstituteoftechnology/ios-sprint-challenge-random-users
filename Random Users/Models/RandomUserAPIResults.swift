//
//  RandomUserAPIResults.swift
//  Random Users
//
//  Created by Jon Bash on 2019-12-06.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class RandomUserAPIResults: Decodable {
    let results: [RandomUser]
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.results = try container.decode([RandomUser].self, forKey: .result)
    }
    
    enum CodingKeys: String, CodingKey {
        case result
    }
}
