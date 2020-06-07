//
//  APIController.swift
//  Random Users
//
//  Created by Vincent Hoang on 6/6/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case noIdentifier
    case noData
    case failedDecode
    case failedEncode
    case otherError
}

class APIController {
    static var baseURL = URL(string: "https://randomuser.me")!
    
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    
    func getUsersFromAPI(completion: @escaping CompletionHandler = { _ in }) {
        
    }
}
