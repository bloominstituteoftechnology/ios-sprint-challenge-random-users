//
//  RandomUser.swift
//  Random Users
//
//  Created by Michael Flowers on 6/21/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class RandomUser: Codable {
    var results: [User]
    
    enum RandomUserKeys: String, CodingKey {
        case results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RandomUserKeys.self)
        var randomUserArrayContainer = try container.nestedUnkeyedContainer(forKey: .results)
        var arrayOfUsers = [User]()
        while randomUserArrayContainer.isAtEnd == false {
            let user = try randomUserArrayContainer.decode(User.self)
            arrayOfUsers.append(user)
        }
        results = arrayOfUsers
    }
}
