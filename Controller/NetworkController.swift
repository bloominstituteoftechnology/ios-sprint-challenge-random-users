//
//  NetworkController.swift
//  Random Users
//
//  Created by Alex Thompson on 1/25/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

enum HTTPMETHOD: String {
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
    case post = "POST"
}

class NetworkController {
    func fetchUsers(completion: @escaping (Error?) -> ()) {
        guard let url = baseURL else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let response = response as? HTTPURLResponse {
                print("Fetch users: \(response.statusCode)")
            }
            
            if let error = error {
                print("An error occured: \(error)")
                return
            }
            
            guard let data = data else { return }
            print(data)
            
            do {
                let decoder = try JSONDecoder().decode(Results.self, from: data)
                self.users = decoder.results
                completion(nil)
            } catch {
                print("An error occured while decoding json: \(error)")
            }
        }.resume()
    }
    
    private var baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")
    private (set) var users: [User] = []
    var largeImageCache = Cache<Int, Data>()
}
