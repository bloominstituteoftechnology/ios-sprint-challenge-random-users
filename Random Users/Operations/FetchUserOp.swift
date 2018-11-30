//
//  fetchUserOp.swift
//  Random Users
//
//  Created by Jerrick Warren on 11/30/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation

class FetchUserOp: ConcurrentOperation {

    var users: [User]?
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    // Start Methods
    
    override func start() {
        state = .isExecuting
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching users: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("No data was returned. Please check your URL.")
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
    
}
