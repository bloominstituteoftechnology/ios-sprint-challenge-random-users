//
//  UserBlock.swift
//  Random Users
//
//  Created by Cody Morley on 6/7/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct UserBlock: Decodable {
    //MARK: - Types -
    enum CodingKeys: String, CodingKey {
        case results
    }
    
    
    //MARK: - Properties -
    var results: [User]
    
    
}
