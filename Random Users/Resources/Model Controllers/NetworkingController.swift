//
//  NetworkingController.swift
//  Random Users
//
//  Created by John McCants on 9/11/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class NetworkingController {
    
var myContacts: Contacts?
let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!

enum URLMethods: String {
    case get = "GET"

}
enum NetworkError: Error {
    case noData
    case noImageData
    case decodeFailed
    case downloadError
}

}
