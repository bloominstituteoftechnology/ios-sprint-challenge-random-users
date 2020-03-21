//
//  Person.swift
//  Random Users
//
//  Created by Sal B Amer on 21/3/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

// Images, Name, title, phone

import Foundation

// MARK: - Person
struct Person: Codable {
    let results: [Result]
    let info: Info
}

// MARK: - Info
struct Info: Codable {
    let seed: String
    let results, page: Int
    let version: String
}

// MARK: - Result
struct Result: Codable {
    let name: Name
    let email, phone: String
    let picture: Picture
}

// MARK: - Name
struct Name: Codable {
    let title: Title
    let first, last: String
}

enum Title: String, Codable {
    case madame = "Madame"
    case mademoiselle = "Mademoiselle"
    case miss = "Miss"
    case monsieur = "Monsieur"
    case mr = "Mr"
    case mrs = "Mrs"
    case ms = "Ms"
}

// MARK: - Picture
struct Picture: Codable {
    let large, medium, thumbnail: String
}
