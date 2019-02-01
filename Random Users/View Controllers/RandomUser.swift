//
//  RandomUser.swift
//  Random Users
//
//  Created by Ivan Caldwell on 2/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation
struct MessageThread: Codable {
    let results: [Result]?
    let info: Info?
}

struct Info: Codable {
    let seed: String?
    let results, page: Int?
    let version: String?
}

struct Result: Codable {
    let name: Name?
    let email, phone: String?
    let picture: Picture?
}

struct Name: Codable {
    let title: Title?
    let first, last: String?
}

enum Title: String, Codable {
    case madame = "madame"
    case mademoiselle = "mademoiselle"
    case miss = "miss"
    case monsieur = "monsieur"
    case mr = "mr"
    case mrs = "mrs"
    case ms = "ms"
}

struct Picture: Codable {
    let large, medium, thumbnail: String?
}
