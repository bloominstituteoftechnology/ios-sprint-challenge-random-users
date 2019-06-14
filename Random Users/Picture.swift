//
//  Picture.swift
//  Random Users
//
//  Created by Michael Flowers on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation
struct Picture: Codable {
    var thumbnail: String
    var large: String
    
    enum CodingKeys: String, CodingKey {
        case thumbnail
        case large
    }
    
    init(from decoder: Decoder)throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        thumbnail = try container.decode(String.self, forKey: .thumbnail)
        large = try container.decode(String.self, forKey: .large)
    }
    
    func encode( with encoder: Encoder) throws {
    
    }
}
