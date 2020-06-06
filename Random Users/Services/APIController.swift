//
//  APIController.swift
//  Random Users
//
//  Created by Cody Morley on 6/5/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class APIController {
    //MARK: - Types -
    enum HTTPMethod: String {
        case get = "GET"
    }
    
    enum NetworkError: Error {
        case badResponse
        case noData
        case noDecode
        case otherError
    }
    
    typealias UsersCompletionHandler = (Result<[User], NetworkError>) -> Void
    
    
    //MARK: - Properties -
    private let baseURL = URL(string: "https://randomuser.me/api/")!
    private lazy var fetchURL: URL = baseURL.appendingPathComponent("?format=json&inc=name,email,phone,picture&results=1000")
    
    
}
