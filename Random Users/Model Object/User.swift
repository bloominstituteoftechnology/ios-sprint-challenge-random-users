//
//  User.swift
//  Random Users
//
//  Created by Samantha Gatt on 9/7/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

struct User: Decodable {
    
    // MARK: - Coding Keys
    
    enum CodingKeys: String, CodingKey {
        case name
        case phoneNumber = "phone"
        case emailAddress = "email"
        case imageURLs = "pictures"
        
        enum NameCodingKeys: String, CodingKey {
            case first
            case last
        }
        
        enum ImageCodingKeys: String, CodingKey {
            case thumbnail
            case large
        }
    }
    
    
    // MARK: - Properties
    
    var name: String
    var phoneNumber: String?
    var emailAddress: String?
    var largeURL: URL?
    var thumbnailURL: URL?
    
    
    // MARK: - Decodable
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let nameContainer = try container.nestedContainer(keyedBy: CodingKeys.NameCodingKeys.self, forKey: .name)
        let first = try nameContainer.decodeIfPresent(String.self, forKey: .first)
        let last = try nameContainer.decodeIfPresent(String.self, forKey: .last)
        
        var name = ""
        if let first = first, let last = last {
            name = "\(first) \(last)"
        } else if let first = first {
            name = first
        } else if let last = last {
            name = last
        }
        
        let phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber)
        let emailAddress = try container.decodeIfPresent(String.self, forKey: .emailAddress)
        
        let imageContainer = try container.nestedContainer(keyedBy: CodingKeys.ImageCodingKeys.self, forKey: .imageURLs)
        let largeURLString = try imageContainer.decodeIfPresent(String.self, forKey: .large)
        let thumbnailURLString = try imageContainer.decodeIfPresent(String.self, forKey: .thumbnail)
        
        var largeURL: URL?
        if let string = largeURLString {
            largeURL = URL(string: string)
        }
        var thumbnailURL: URL?
        if let string = thumbnailURLString {
            thumbnailURL = URL(string: string)
        }
        
        self.name = name
        self.phoneNumber = phoneNumber
        self.emailAddress = emailAddress
        self.largeURL = largeURL
        self.thumbnailURL = thumbnailURL
    }
}
