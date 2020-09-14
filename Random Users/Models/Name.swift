//
//  Name.swift
//  Random Name
//
//  Created by Sammy Alvarado on 9/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

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
