//
//  UserController.swift
//  Random Users
//
//  Created by Kevin Stewart on 5/15/20.
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

enum HTTPMethod: String {
    case get = "GET"
}

class UserController {
    
    var contactList: [User] = []
    typealias CompletionHandler = (NetworkError) -> Void
    
    let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
    func fetchUsersFromServer(completion: @escaping CompletionHandler = { _ in }) {
            let requestURL = baseURL
//                .appendingPathExtension("json")
                   
            var request = URLRequest(url: requestURL)
            request.httpMethod = HTTPMethod.get.rawValue

            URLSession.shared.dataTask(with: requestURL) { (data, _, error) in

                guard let data = data else {
                    NSLog("Error: No data returned from data task")
                    DispatchQueue.main.async {
                        completion(.noData)
                    }
                    return
                }
                
                if let error = error {
                    NSLog("Error fetching users: \(error)")
                    DispatchQueue.main.async {
                        completion(.otherError)
                    }
                    return
                }
                
                do {
                    let fetchedUser = try JSONDecoder().decode(Results.self, from: data)
                    self.contactList = fetchedUser.results
                    completion(.otherError)
                } catch {
                    NSLog("Error decoding user representations: \(error)")
                    DispatchQueue.main.async {
                        completion(.noDecode)
                    }
                }
            }.resume()
        }
}


      
