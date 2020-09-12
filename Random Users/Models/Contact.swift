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
    let imageURL: String
    let phoneNumber: String
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



//SAMPLE JSON
/*
{
  "results": [
    {
      "name": {
        "title": "mr",
        "first": "brad",
        "last": "gibson"
      },
      "email": "brad.gibson@example.com",
      "phone": "011-962-7516",
      "picture": {
        "large": "https://randomuser.me/api/portraits/men/75.jpg",
        "medium": "https://randomuser.me/api/portraits/med/men/75.jpg",
        "thumbnail": "https://randomuser.me/api/portraits/thumb/men/75.jpg"
      },
}
/*
