//
//  UserController.swift
//  Random Users
//
//  Created by Lambda_School_Loaner_268 on 3/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

// MARK: - UserResults
struct UserResults: Codable {
    var results: [User]
    
    enum resultKey: String, CodingKey {
        case results
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: resultKey.self)
        let resultsContainer = try container.decode([User].self, forKey: .results)
        results = resultsContainer
    }
}


// MARK: - USER + ENUMS

struct User: Codable {
    // MARK: - Properties
    var name: String
    var number: String
    var thumbnail: URL
    var large: URL
    var email: String
    var location: String
    // MARK: - Enums
    enum UserKeys: String, CodingKey{
        case name
        case number
        case thumbnail
        case large
        case email
        case location
    }
    enum NameKeys: String, CodingKey {
        case title
        case first
        case last
    }
    enum PictureKeys: String, CodingKey {
        case large
        case thumbnail
        case medium
    }
    enum LocationKeys: String, CodingKey {
        case street
        case city
        case state
        case postcode
    }
    // MARK: - INIT
    init(from decoder: Decoder) throws {
        // User Container
        let container = try decoder.container(keyedBy: UserKeys.self)
        // Name Container
        let nameContainer = try container.nestedContainer(keyedBy: NameKeys.self, forKey: .name)
            let title = try nameContainer.decode(String.self, forKey: .title)
            let first = try nameContainer.decode(String.self, forKey: .first)
            let last = try nameContainer.decode(String.self, forKey: .last)
        // User Name
        name = "\(title) \(first) \(last)"
        // User Email
        email = try container.decode(String.self, forKey: .email)
        // User Number
        number = try container.decode(String.self, forKey: .number)
        // Thumbnail URL Container
        let thumbnailContainer = try decoder.nestedContainer(keyedBy: PictureKeys.self, forKey: .thumbnail)
            // Thumbnail URL
            thumbnail = try thumbnailContainer.decode(URL.self, forKey: .thumbnail)
        // Large URL Container
        let largeContainer = try decoder.nestedContainer(keyedBy: PictureKeys.self, forKey: .large)
            // Large URL
            large = try largeContainer.decode(URL.self, forKey: .large)
        // Address Container
        let addressContainer = try decoder.nestedContainer(keyedBy: LocationKeys.self, forKey: .location)
            // User Street
            let street = try addressContainer.decode(String.self, forKey: .street)
            // User City
            let city = addressContainer.decode(String.self, forKey: .city)
            // User State
            let state = addressContainer.decode(String.self, forKey: .state)
            // User Postal Code
            let postcode = addressContainer.decode(String.self, forKey: .postcode)
        // Full Location
        location = "\(street) \(city), \(state) \(postcode)"
    }
}
