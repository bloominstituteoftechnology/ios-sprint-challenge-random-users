//
//  RandomUserController.swift
//  Random Users
//
//  Created by David Williams on 7/19/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class RandomUserController {
    
    
    
    let baseURL = URL(string: " https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    enum NetworkError: Error {
        case noAuth
        case unauthorized
        case otherError(Error)
        case noData
        case decodeFailed
        case failedSignUp
        case failedSignIn
        case noToken
        case failPost
        case tryAgain
    }
}
