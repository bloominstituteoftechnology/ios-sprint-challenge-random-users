//
//  User.swift
//  Random Users
//
//  Created by Jason Modisett on 10/12/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation

struct Users {
    let results: [User]
}

struct User: Codable {
    let gender: String
    let name: UserName
    let location: UserLocation
    let email: String
    let dob: UserBirthday
    let phone: String
    let cell: String
    let picture: UserPicture
        
    struct UserName: Codable {
        let title: String
        let first: String
        let last: String
        
        init(title: String, first: String, last: String) {
            self.title = title.capitalized.appending(".")
            self.first = first.capitalized
            self.last = last.capitalized
        }
    }
    
    struct UserLocation: Codable {
        let street: String
        let city: String
        let state: String
        let postcode: String
        
        init(street: String, city: String, state: String, postcode: String) {
            self.street = street.capitalized
            self.city = city.capitalized
            self.state = state.capitalized
            self.postcode = postcode
        }
    }
    
    struct UserBirthday: Codable {
        let date: String
        
        init(date: String) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            let date = dateFormatter.date(from: date)!
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            self.date = dateFormatter.string(from: date)
        }
    }
    
    struct UserPicture: Codable {
        let thumbnail: String
        
        init(thumbnail: String) {
            self.thumbnail = thumbnail
        }
    }

}
