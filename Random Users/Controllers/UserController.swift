//
//  UserController.swift
//  Random Users
//
//  Created by Lambda_School_Loaner_259 on 4/10/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class UserController {
    
    // MARK: - Properties
    let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    //var users: [User] = []
    
    
    // MARK: - CRUD
    // none needed in this app
    
    
    // MARK: - Fetch methods
    
    func fetchUsers(completion: @escaping ([User]?, Error?) -> Void) {
        //let urlRequest = URLRequest(url: baseURL)
        URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching all users: \(error)")
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, error)
                NSLog("Fetch resulted in no data")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(Result.self, from: data)
                //self.users = decodedData
                //let values = Array(decodedData.values).first
                let values = decodedData.results
                
                completion(values, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
}
