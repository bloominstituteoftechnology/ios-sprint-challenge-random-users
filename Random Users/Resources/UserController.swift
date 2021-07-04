//
//  UserController.swift
//  Random Users
//
//  Created by Julian A. Fordyce on 3/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit


private let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!

class UserController {
    
    func fetchRandomUsers(completion: @escaping (Error?) -> Void = {_ in }) {
    
        let requestURL = baseURL
        
           let dataTask = URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
                if let error = error {
                    NSLog("Unable to retrieve data: \(error)")
                    completion(error)
                    return
                }
                
                guard let data = data else {
                    NSLog("Unable to retrieve data: \(String(describing: error))")
                    completion(error)
                    return
                }
                
                print(data)
                
                do {
                    let jsonDecoder = JSONDecoder()
                    
                    let randomUsers = try jsonDecoder.decode(Users.self, from: data)
                    self.users = randomUsers.results
                    completion(nil)
                } catch {
                    NSLog("Unable to decode JSON: \(error)")
                    completion(error)
                    return
                }
            }
        
        dataTask.resume()
    }
    
        
        // MARK: - Properties
    
        private(set) var users: [User] = []
    
}
    
    
    
    
    

