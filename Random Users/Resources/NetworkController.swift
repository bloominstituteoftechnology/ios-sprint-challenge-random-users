//
//  NetworkController.swift
//  Random Users
//
//  Created by Ryan Murphy on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class NetworkController {
    
    var users: [User] = []
    
    let baseURL = URL(string: "https://randomuser.me/api/")!
    
    func fetchUsers(completion: @escaping (Error?) -> Void = {_ in }) {
        
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let format = URLQueryItem(name: "format", value: "json")
        let including = URLQueryItem(name: "inc", value: "name,email,phone,picture")
        let results = URLQueryItem(name: "results", value: "2000")
        
        urlComponents?.queryItems = [format, including, results]
        
        guard let url = urlComponents?.url else {
            print("Can't find URL")
            completion(NSError())
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                NSLog("Error connnecting to server: \(error)")
                print("Can't connect to server ")
                completion(error)
                return
            }
            
            guard let data = data else {
                print("Can't fetch Data")
                completion(NSError())
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedUsers = try decoder.decode(Results.self, from: data)
                self.users = decodedUsers.results
            } catch {
                print("Couldn't decode Data")
                completion(error)
                return
            }
            completion(nil)
            }.resume()
    }
}
