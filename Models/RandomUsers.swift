//
//  RandomUsers.swift
//  Random Users
//
//  Created by Joe on 1/25/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct Result: Codable {
    var results: [Person]
    
}

struct Person: Codable {
    let name: Name
    let email: String
    let phone: String
    let picture: Picture
    
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
    
}



             


                    
            
        
        





