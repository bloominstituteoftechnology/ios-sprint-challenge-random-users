//
//  UserController.swift
//  Random Users
//
//  Created by Waseem Idelbi on 5/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case noIdentifier
    case otherError
    case noData
    case noDecode
    case noEncode
    case noRep
}

class UserController {
    
    //MARK: - Properties -
    
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    let baseURL: URL = URL(string: "https://randomuser.me/api/")!
    var users: [User] = []
    
    //MARK: - Methods -
    
    func getUser(completion: CompletionHandler) {
        
    }
    
    
}
