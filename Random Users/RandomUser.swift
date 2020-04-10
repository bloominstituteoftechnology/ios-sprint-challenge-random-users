//
//  RandomUser.swift
//  Random Users
//
//  Created by Mark Gerrior on 4/10/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct Name: Decodable {
    enum CodingKeys: String, CodingKey {
        case title
        case first
        case last
    }

    let title: String // mr
    let first: String // brad
    let last: String // gibson
}

struct Picture: Decodable {
    enum CodingKeys: String, CodingKey {
        case large
        case medium
        case thumbnail
    }

    let large: String // https://randomuser.me/api/portraits/men/75.jpg
    let medium: String // https://randomuser.me/api/portraits/med/men/75.jpg
    let thumbnail: String // https://randomuser.me/api/portraits/thumb/men/75.jpg
}

struct MarsRover: Decodable { // FIXME:

    enum CodingKeys: String, CodingKey {
        case name
        case email
        case phone
        case cell
        case picture
    }

    let name: Name

    let email: String // brad.gibson@example.com
    let phone: String // 011-962-7516
    let cell: String // 081-454-0666

    let picture: Picture
}
