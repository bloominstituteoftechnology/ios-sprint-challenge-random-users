//
//  Friend.swift
//  Random Users
//
//  Created by Craig Swanson on 1/26/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

struct Friend: Decodable {
    var title: String
        var first: String
        var last: String
        var email: String
        var phone: String
        var large: URL
        var thumbnail: URL
    }

struct Result {
    
    var results: [Friend]
    
    enum ResultsKeys: String, CodingKey {
        case results
        
        enum FriendKeys: String, CodingKey {
            case name
            case email
            case phone
            case picture
            
            enum NameKeys: String, CodingKey {
                case title
                case first
                case last
            }
            
            enum PictureKeys: String, CodingKey {
                case large
                case thumbnail
            }
        }
    }
}

extension Result: Decodable {
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: ResultsKeys.self)
        var resultContainer = try container.nestedUnkeyedContainer(forKey: .results)
        
        var friendList: [Friend] = []
        while !resultContainer.isAtEnd {
            let friendContainer = try resultContainer.nestedContainer(keyedBy: ResultsKeys.FriendKeys.self)
            
            let phone = try friendContainer.decode(String.self, forKey: .phone)
            let email = try friendContainer.decode(String.self, forKey: .email)
            
            let nameContainer = try friendContainer.nestedContainer(keyedBy: ResultsKeys.FriendKeys.NameKeys.self, forKey: .name)
            
            let title = try nameContainer.decode(String.self, forKey: .title)
            let first = try nameContainer.decode(String.self, forKey: .first)
            let last = try nameContainer.decode(String.self, forKey: .last)
            
            let photosContainer = try friendContainer.nestedContainer(keyedBy: ResultsKeys.FriendKeys.PictureKeys.self, forKey: .picture)
            
            let large = try photosContainer.decode(URL.self, forKey: .large)
            let thumbnail = try photosContainer.decode(URL.self, forKey: .thumbnail)
            
            let newFriend = Friend(title: title, first: first, last: last, email: email, phone: phone, large: large, thumbnail: thumbnail)
            
            friendList.append(newFriend)
        }
        results = friendList
        
    }
}
