//
//  UserController.swift
//  Random Users
//
//  Created by Bhawnish Kumar on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum NetworkError: Error {
    case noAuth
    case badAuth
    case otherNetworkError
    case badData
    case noDecode
    case badUrl
}

class UserController {
    
    private let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
}
