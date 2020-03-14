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
    
    var users: [User] = []
    
    func fetchUsers(completion: @escaping ((Error?) -> Void)){
        
        var request = URLRequest(url: Keys.requestURL)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                completion(error)
                NSLog("Error fetching Users: \(error)")
                return
            }
            guard let data = data else {
                NSLog("Bad data")
                completion(NSError())
                return
            }
            
            do{
                let usersData = try JSONDecoder().decode(Users.self,
                                                   from: data)
                self.users = usersData.results
            } catch {
                NSLog("\(error)")
            }
        }.resume()
    }
    
    func fetchPictures(for URLString: String, completion: @escaping (Result<Data, Error>) -> Void) {
      
        guard let imageURL = URL(string: URLString) else { return }
        
        var request = URLRequest(url: imageURL)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching data: \(error)")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                NSLog("Error fetching data")
                completion(.failure(NSError()))
                return
            }
            
            completion(.success(data))
        }.resume()
    }
    
}
