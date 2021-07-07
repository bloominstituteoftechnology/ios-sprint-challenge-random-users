//
//  Result.swift
//  Random Users
//
//  Created by Diante Lewis-Jolley on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct Result: Decodable {

    let results: [User]

    enum CodingKeys: String, CodingKey {
        case results
    }

    init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        let results = try container.decode([User].self, forKey: .results)

        self.results = results
    }
}
