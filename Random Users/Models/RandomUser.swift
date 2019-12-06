//
//  RandomUser.swift
//  Random Users
//
//  Created by Jon Bash on 2019-12-06.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class RandomUser: Decodable {
    let name: String
    let phoneNumber: String
    let emailAddress: String
    
    let imageInfo: ImageInfo
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let nameContainer = try container.nestedContainer(keyedBy: CodingKeys.NameKeys.self, forKey: .name)
        
        let title = try nameContainer.decode(String.self, forKey: .title).capitalized
        let first = try nameContainer.decode(String.self, forKey: .first).capitalized
        let last = try nameContainer.decode(String.self, forKey: .last).capitalized
        
        self.name = "\(title). \(first) \(last)"
        self.phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
        self.emailAddress = try container.decode(String.self, forKey: .email)
        self.imageInfo = try container.decode(ImageInfo.self, forKey: .imageInfo)
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case phoneNumber = "phone"
        case email = "email"
        
        case imageInfo = "picture"
        
        enum NameKeys: String, CodingKey {
            case title, first, last
        }
    }
    
    class ImageInfo: Decodable {
        let thumbnailURL: URL?
        let fullImageURL: URL?
        
        var thumbnailData: Data?
        var fullImageData: Data?
        
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            let thumbnailURLString = try container.decode(String.self, forKey: .thumbnailURL)
            let fullImageURLString = try container.decode(String.self, forKey: .fullImageURL)
            
            self.thumbnailURL = URL(string: thumbnailURLString)
            self.fullImageURL = URL(string: fullImageURLString)
        }
        
        enum CodingKeys: String, CodingKey {
            case thumbnailURL = "thumbnail"
            case fullImageURL = "large"
        }
    }
}

extension RandomUser: Equatable {
    static func == (lhs: RandomUser, rhs: RandomUser) -> Bool {
        return lhs === rhs
    }
}
