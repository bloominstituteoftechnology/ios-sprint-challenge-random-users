//
//  FetchUsersOperation.swift
//  Random Users
//
//  Created by Scott Bennett on 12/27/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class FetchUsersOperation: ConcurrentOperation {
    
    // MARK: - Properties
    
    var users: [User]?
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    // Fetch users
    override func start() {
        state = .isExecuting
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                NSLog("Error fetcing users: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("Error receiving data.")
                return
            }
            
            do {
                let results = try JSONDecoder().decode(Results.self, from: data)
                self.users = results.results
            } catch {
                NSLog("Error decoding users.")
                return
            }
            
            defer {
                self.state = .isFinished
            }
        }.resume()
    }
}
