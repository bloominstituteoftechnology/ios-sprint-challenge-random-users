//
//  FetchUsersOperation.swift
//  Random Users
//
//  Created by Chad Rutherford on 1/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class FetchUsersOperation: ConcurrentOperation {
    var users: [User]?
    
    override func start() {
        self.state = .isExecuting
        
        guard let baseURL = URL(string: "https://randomuser.me/api/") else { return }
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let formatItem = URLQueryItem(name: "format", value: "json")
        let includeItem = URLQueryItem(name: "inc", value: "name,email,phone,picture")
        let resultsItem = URLQueryItem(name: "results", value: "1000")
        components?.queryItems = [formatItem, includeItem, resultsItem]
        guard let requestURL = components?.url else { return }
        
        URLSession.shared.dataTask(with: requestURL) { data, _, error in
            defer { self.state = .isFinished }
            
            if let _ = error {
                return
            }
            
            guard let data = data else { return }
            
            let decoder = JSONDecoder()
            do {
                let results = try decoder.decode(Results.self, from: data)
                self.users = results.results
            } catch {
                return
            }
        }.resume()
    }
}
