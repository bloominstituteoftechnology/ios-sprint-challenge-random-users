//
//  FetchUsersOperation.swift
//  Random Users
//
//  Created by Daniela Parra on 10/12/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class FetchUsersOperation: ConcurrentOperation {
    
    init(url: URL) {
        self.url = url
    }
    
    override func start() {
        state = .isExecuting
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching users: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("No data was returned.")
                return
            }
            
            do {
                let results = try JSONDecoder().decode(Results.self, from: data)
                self.users = results.results
                
            } catch {
                NSLog("Error decoding users")
                return
            }
            
            defer {
                self.state = .isFinished
            }
        }.resume()
    }
    
    
    var users: [User]?
    let url: URL
}
