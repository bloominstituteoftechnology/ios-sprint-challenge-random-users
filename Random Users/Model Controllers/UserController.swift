//
//  UserController.swift
//  Random Users
//
//  Created by Niranjan Kumar on 12/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum NetworkingError: Error {
    case noData
    case noBearer
    case serverError(Error)
    case unexpectedStatusCode
    case badDecode
    case badEncode
    case fetchError
}

class UserController {
    
    var users: [User] = []
    
    let baseURL = URL(string: "https://randomuser.me/api/?format=json&results=1000")!
    
    func fetchUsers(completion: @escaping (NetworkingError?) -> Void) {
        URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
            if let error = error {
                print("Error fetching users: \(error)")
                print("\(#file):L\(#line): Code failed inside \(#function)")
                completion(nil)
            }
            
            guard let data = data else {
                print("Error with Data")
                print("\(#file):L\(#line): Code failed inside \(#function)")
                completion(.noData)
                return
            }
            
            do {
                let newUsers = try JSONDecoder().decode(RandomUsers.self, from: data)
                self.users = newUsers.results
            } catch {
                print("Error decoding users: \(error)")
                completion(.badDecode)
            }
            completion(nil)
        }
    }
    
    
}

