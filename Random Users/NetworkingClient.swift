//
//  NetworkingClient.swift
//  Random Users
//
//  Created by Kelson Hartle on 6/7/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation


enum NetworkError: Error {
    case noData, failedSignUP, unableToCreateGig, failedSignIn, tryagain, noToken
}

struct Client {
    
    func loadUsers(completion: @escaping (Result<[User], NetworkError>) -> Void) {
        let url = URL(string: "https://randomuser.me/api?results=999")!
        let task = URLSession.shared.dataTask(with: url) {data, response, error in
            var users = [User]()
            if let data = data {
                users = parseUsersJSON(from: data)
            }
            
            if let error = error {
                print(error)
            }
            
            completion(.success(users))
        }
        task.resume()
    }
}

    func parseUsersJSON(from data: Data) -> [User] {
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                var users = [User]()
                for userJSON in json.array("results") {
                    if let user = User(json: userJSON) {
                        users.append(user)
                    }
                }
                return users
            }
        } catch {
            print("Couldn't parse JSON: \(error)")
            if let utf8String = String(data: data, encoding: String.Encoding.utf8) {
                print("Received: \(utf8String)")
            }
        }
        
        return []
    }
