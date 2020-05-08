//
//  APIController.swift
//  Random Users
//
//  Created by Harmony Radley on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class UserController {
    
    private let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
    var results: Results?
    
    // GET
    
    func getRandomUser(completion: @escaping ((Error?) -> Void) = { _ in}) {
        
        var request = URLRequest(url: baseURL)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print(error)
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from data task")
                completion(NSError())
                return
            }
            
            do {
                let decoder = try JSONDecoder().decode(Results.self, from: data)
                self.results = decoder
                completion(nil)
            } catch {
                print(error)
                NSLog("Error decoding: \(error)")
                completion(error)
            }
        }.resume()
    }
}

