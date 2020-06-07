//
//  User.swift
//  Random Users
//
//  Created by Kelson Hartle on 6/7/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation


struct User {
    let title: String
    let first: String
    let last: String
    let email: String
    let phone: String
    //let postCode: String
    let thumbnail: URL
    let large: URL
    //    let fullProfile: URL
    init?(json: [String: Any]) {
        guard let name = json.dict("name") else { return nil }
        guard let title = name.string("title") else { return nil }
        guard let first = name.string("first") else { return nil }
        guard let last = name.string("last") else { return nil }
        guard let email = json.string("email") else { return nil }
        guard let phone = json.string("phone") else { return nil }
        //guard let location = json.dict("location") else { return nil }
        //guard let postcode = location.string("postcode") else { return nil }
        guard let thumbnail = json.dict("picture")?.string("thumbnail") else { return nil }
        guard let thumbnailURL = URL(string: thumbnail) else { return nil }
        guard let large = json.dict("picture")?.string("large") else { return nil }
        guard let largeURL = URL(string: large) else { return nil }
        
        self.title = title
        self.first = first
        self.last = last
        self.email = email
        self.phone = phone
        //self.postCode = postcode
        self.thumbnail = thumbnailURL
        self.large = largeURL
    }
}
