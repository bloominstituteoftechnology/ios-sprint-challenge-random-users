//
//  RandomUserController.swift
//  Random Users
//
//  Created by Vici Shaweddy on 11/9/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

class RandomUserController {
    var users: [RandomUser] = []
    let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
    func getUsers(completion: @escaping ([RandomUser]?, Error?) -> Void) {
        URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
            guard error == nil else {
                completion(nil, error)
                return
                
            }
            
            guard let data = data else {
                NSLog("No data returned from data task")
                completion(nil, error)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let results = try decoder.decode(Results.self, from: data)
                self.users = results.results
                completion(self.users, nil)
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }.resume()
    }
}
