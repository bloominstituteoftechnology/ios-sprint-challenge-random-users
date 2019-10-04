//
//  Person.swift
//  Random Users
//
//  Created by Joshua Sharp on 10/4/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct Results: Codable {
    let results: [Person]
}

struct Person: Codable {
    let id:         UUID = UUID()
    let name:       Name
    let email:      String
    let phone:      String
    let picture:    Picture
    
}

struct Name: Codable {
    let title:      String
    let first:      String
    let last:       String
}

struct Picture: Codable {
    let id:         UUID = UUID()
    let large:      String
    let medium:     String
    let thumbnail:  String
}
