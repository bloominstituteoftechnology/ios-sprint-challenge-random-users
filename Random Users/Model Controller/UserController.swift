//
//  UserController.swift
//  Random Users
//
//  Created by Seschwan on 8/2/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

class UserController {
    
    // Data Source to store requested values
    var usersArray = [User]()
    
    typealias CompletionHandler = (Error?) -> Void
    

    private let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
    func fetchUsers(completion: @escaping CompletionHandler = { _ in }) {
        URLSession.shared.dataTask(with: baseURL) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                print("Response Code: \(response.statusCode)")
            }
            
            if let error = error {
                NSLog("Error fetching data: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else { NSLog("Error with the data: \(error)")
                return
            }
            
            let jsonDecoder = JSONDecoder()
            
            do {
                let users = try jsonDecoder.decode(RandomUser.self, from: data).results
                self.usersArray = users
            } catch {
                NSLog("Error decoding the data: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
}
