//
//  User.swift
//  Random Users
//
//  Created by Cody Morley on 6/7/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation
struct User: Decodable {
    //MARK: - Keys -
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case phone
        case picture
        
        enum NameKeys: String, CodingKey {
            case first
            case last
            case title
        }
        
        enum ImageKeys: String, CodingKey {
            case detailImage = "large"
            case thumbnailImage = "thumbnail"
        }
    }
    
    //MARK: - Properites -
    let id: UUID
    let title: String
    let name: String
    let email: String
    let phone: String
    let detailImage: URL
    let thumbnailImage: URL
    
    
    //MARK: - Initializers -
    init(from decoder: Decoder) throws {
        self.id = UUID()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let nameContainer = try container.nestedContainer(keyedBy: CodingKeys.NameKeys.self, forKey: .name)
        let imageContainer = try container.nestedContainer(keyedBy: CodingKeys.ImageKeys.self, forKey: .picture)
        
        self.email = try container.decode(String.self, forKey: .email)
        self.phone = try container.decode(String.self, forKey: .phone)
    
        self.title = try nameContainer.decode(String.self, forKey: .title)
        let first = try nameContainer.decode(String.self, forKey: .first)
        let last = try nameContainer.decode(String.self, forKey: .last)
        self.name = "\(first) \(last)"
        
        let detailString = try imageContainer.decode(String.self, forKey: .detailImage)
        let thumbnailString = try imageContainer.decode(String.self, forKey: .thumbnailImage)
        self.detailImage = URL(string: detailString)!
        self.thumbnailImage = URL(string: thumbnailString)!
    }
}

///This struct only exists to provide a step in the decoding process. It should not be used with any controllers.

struct UserBlock: Decodable {
    enum CodingKeys: String, CodingKey {
        case results
    }
    var results: [User]
}
