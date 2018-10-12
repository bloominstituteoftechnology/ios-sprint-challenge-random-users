//
//  NetworkHelpers.swift
//  Random Users
//
//  Created by Dillon McElhinney on 10/12/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation

/// HTTPMethod is an enum that holds the strings of possible HTTP Request Methods. Use .rawValue instead of writing a string.
enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

typealias CompletionHandler = (Error?) -> Void
