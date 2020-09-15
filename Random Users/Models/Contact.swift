//
//  Contact.swift
//  Random Users
//
//  Created by BrysonSaclausa on 9/12/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation


struct Contact: Codable {
    let name: Name
    let picture : Picture
    let phone: String
    let email: String
}

struct Name: Codable {
    let title: String
    let first: String
    let last: String
}

struct Picture: Codable {
    let large: String
    let medium: String
    let thumbnail: String
}

struct ContactResults: Codable {
    let results: [Contact]
}



