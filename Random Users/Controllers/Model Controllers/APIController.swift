//
//  APIController.swift
//  Random Users
//
//  Created by Sal B Amer LpTop on 21/3/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

class APIController {
    
    let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")
    
    typealias CompletionHandler = (Error?) -> Void
    
}
