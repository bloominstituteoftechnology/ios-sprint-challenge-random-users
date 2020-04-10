//
//  FetchUserOperation.swift
//  Random Users
//
//  Created by Lambda_School_Loaner_268 on 3/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

// MARK: - FetchUserOperation
class FetchUserOperation: ConcurrentOperation {

// MARK: - Properties
    var users: [User]?

// MARK: - Methods/Overrides
    
override func start() {
    self.state = .isExecuting
    guard let baseURL = URL(string: "https://randomuser.me/api/") else {return}
    var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
    var format = URLQueryItem(name: "format", value: "json")
    var include = URLQueryItem(name: "inc", value: "name,number,email,location,picture")
    var results = URLQueryItem(name: "results", value: "1000")
    components?.queryItems = [format, include, results]
    guard let request = components?.url else { return }
    URLSession.shared.dataTask(with: request) { (data, _, error) in
        defer { self.state = .isFinished }
        if let error = error {
            print(error)
            return
        }
        guard let data = data else {
            print("No data")
            return
        }
        do {
            let results = try decoder.decode(UserResults.self, from: data)
            self.users = results.results
        } catch {
            return
        }
    }.resume()
    }
}
