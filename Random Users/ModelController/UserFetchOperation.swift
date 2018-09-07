//
//  UserFetchOperation.swift
//  Random Users
//
//  Created by Carolyn Lea on 9/7/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation

class UserFetchOperation: ConcurrentOperation
{
    private var dataTask: URLSessionDataTask?
    var userController: UserController?
    var user: User?
    
    override func start()
    {
        state = .isExecuting
        
        let url = userController?.baseURL
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error
            {
                NSLog("error fetching users from server \(error)")
                
                return
            }
            
            guard let data = data else {
                
                NSLog("Error fetching data. No data returned")
                //completion(nil, NSError())
                return
            }
            
            do
            {
                let jsonDecoder = JSONDecoder()
                let results = try jsonDecoder.decode(User.self, from: data)
                
                DispatchQueue.main.async() {
                    
                    let _ = results
                    
                    self.state = .isFinished
                }
                
            }
            catch
            {
                NSLog("Unable to decode data into user: \(error)")
                //completion(nil, error)
                return
            }
        }
        .resume()
    }
    
    override func cancel()
    {
        dataTask?.cancel()
    }
}
