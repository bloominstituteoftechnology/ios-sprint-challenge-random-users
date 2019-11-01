//
//  RandomPerson.swift
//  Random Users
//
//  Created by Gi Pyo Kim on 11/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct RandomPerson: Codable {
    let results: [Person]
}

struct Person: Codable {
    let name: Name
    let email: String
    let phone: String
    let picture: Picture
    
    struct Name: Codable {
        let title: String
        let first: String
        let last: String
    }
}

struct Picture: Codable {
    let large: String
    let thumbnail: String
    let id: UUID?
}
