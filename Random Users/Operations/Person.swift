//
//  Person.swift
//  Random Users
//
//  Created by Vuk Radosavljevic on 9/7/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//


import Foundation


struct Person: Codable, Equatable {


    let email: String
    let phone: String
    let name: [String: String]
    let picture: [String: String]

}


struct People: Codable, Equatable {
    let results: [Person]
}
