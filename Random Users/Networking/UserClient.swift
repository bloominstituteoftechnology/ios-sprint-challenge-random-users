//
//  UserClient.swift
//  Random Users
//
//  Created by Chris Gonzales on 3/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

class UserClient {
    
    func fetchUsers(completion: @escaping ((Result<User, Error>) -> Void)){
        var request = URLRequest(url: Keys.requestURL)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                completion(.failure(error))
                NSLog("Error fetching Users: \(error)")
                return
            }
            guard let data = data else {
                NSLog("Bad data")
                completion(.failure(NSError()))
                return
            }
            
            do{
                let newUser = try JSONDecoder().decode(User.self,
                                                   from: data)
                completion(.success(newUser))
            } catch {
                NSLog("\(error)")
            }
        }.resume()
    }
    
    func fetchThumbnail(for user: User, completion: @escaping (Result<UIImage?, Error>) -> Void) {
        
    }
    
}
