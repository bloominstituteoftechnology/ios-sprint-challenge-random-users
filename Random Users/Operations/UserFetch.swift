//
//  UserFetch.swift
//  Random Users
//
//  Created by Lambda_School_loaner_226 on 7/20/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class UserFetch: ConcurrentOperation {
    
    private let amountOfUsers: Int
    private let urlSession: URLSession
    private var urlDataTask: URLSessionDataTask?
    private(set) var userResults: [User]?
    private(set) var userError: Error?
    
    init(amountOfUsers: Int, urlSession: URLSession = URLSession.shared) {
        self.amountOfUsers = amountOfUsers
        self.urlSession = urlSession
        super.init()
    }
    
    override func cancel() {
        urlDataTask?.cancel()
        super.cancel()
    }
    
    override func start() {
        if isCancelled { return }
        
        state = .isExecuting
        
        func userFetching(amountOfUsers: Int) -> URL {
            let endPoint = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture")!
            var components = URLComponents(url: endPoint, resolvingAgainstBaseURL: true)!
            components.queryItems = [URLQueryItem(name: "format", value: "json"),
                                     URLQueryItem(name: "inc", value: "name,email,phone,picture"),
                                     URLQueryItem(name: "results", value: String(amountOfUsers))]
            return components.url!
        }
        
        let url = userFetching(amountOfUsers: amountOfUsers)
        let task = urlSession.dataTask(with: url) { (data, response, error) in
            defer { self.state = .isFinished }
            if self.isCancelled { return }
            if let error = error {
                NSLog("Error fetching user data: \(error)")
                self.userError = error
                return
            }
            
            guard let data = data else {
                NSLog("No data to display")
                return
            }
            
            do {
                let queryResult = try JSONDecoder().decode(Queries.self, from: data)
                self.userResults = queryResult.results
            } catch {
                NSLog("Error decoding users data: \(error)")
                self.userError = error
            }
        }
        task.resume()
        urlDataTask = task
    }
}
