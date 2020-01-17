//
//  NetworkController.swift
//  Random Users
//
//  Created by Alex Shillingford on 1/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

class NetworkController {
    private let baseURL = URL(string: "https://randomuser.me/api/?results=1000")!
    var users: [User] = []
    
    func fetchUsers() {
        
    }
}
