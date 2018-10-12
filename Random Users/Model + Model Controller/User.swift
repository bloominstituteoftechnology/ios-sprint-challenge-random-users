//
//  User.swift
//  Random Users
//
//  Created by Jason Modisett on 10/12/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation

struct Users: Codable {
    let results: [User]
}

struct User: Codable {
    let gender: String
    let name: UserName
    let email: String
    let dob: UserBirthday
    let phone: String
    let cell: String
    let picture: UserPicture
        
    struct UserName: Codable {
        let title: String
        let first: String
        let last: String
        
        var formatted: (String, String, String, String) {
            get {
                let titleFormatted = title.appending(".").capitalized
                let firstFormatted = first.capitalized
                let lastFormatted = last.capitalized
                let full = firstFormatted + " " + lastFormatted
                return (title: titleFormatted, first: firstFormatted, last: lastFormatted, full: full) }
        }
    }
    
    struct UserBirthday: Codable {
        let date: String
        
        var formatted: String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            let date = dateFormatter.date(from: self.date)!
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            return dateFormatter.string(from: date)
        }
    }
    
    struct UserPicture: Codable {
        let thumbnail: String
        let large: String
    }
}
