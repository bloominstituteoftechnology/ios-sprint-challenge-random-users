//
//  UserController.swift
//  Random Users
//
//  Created by Matthew Martindale on 5/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class UserController {
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
    var results: [User] = []
    
    func fetchUsers(completion: @escaping () -> Void) {
        var request = URLRequest(url: baseURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error completing dataTask: \(error)")
                completion()
                return
            }
            
            guard let data = data else {
                NSLog("Error returning data")
                completion()
                return
            }
            
            let jsonDecoder = JSONDecoder()
            
            do {
                self.results = []
                let userFetchResults = try jsonDecoder.decode(Results.self, from: data)
                self.results = userFetchResults.results
            } catch {
                NSLog("Error: unable to decode data: \(error)")
            }
        }.resume()
    }
    
}
