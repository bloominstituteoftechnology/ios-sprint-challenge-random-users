//
//  UsersController.swift
//  Random Users
//
//  Created by Joshua Rutkowski on 3/22/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

//URL: https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000
let baseURL = URL(string: "https://randomuser.me/api/")!

class UsersController {
    
    var users = Results()
    
    func fetchUsers(completion: @escaping (Error?) -> Void) {
        getUsers(amount: 1000) { (results: Results?, error) in // set minimum amount to 1000
            guard let results = results else {
                completion(error)
                return
            }
            self.users = results
            completion(nil)
        }
    }
    
    private func getUsers<T: Codable>(amount num: Int, completion: @escaping (T?, Error?) -> Void) {
        
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = [
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "inc", value: "name,email,phone,picture"),
            URLQueryItem(name: "results", value: String(num))
        ]

        guard let requestURL = urlComponents?.url else {
            completion(nil, NSError())
            return
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "content-type")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            
            if let error = error {
                print(error)
                completion(nil, error)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let jsonDecoder = JSONDecoder()
                let decodedObjects = try jsonDecoder.decode(T.self, from: data)
                completion(decodedObjects, nil)
            } catch {
                print("Error decoding users: \(error)")
                completion(nil, error)
                return
            }
        }.resume()
    }
}
