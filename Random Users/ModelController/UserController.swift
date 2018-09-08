//
//  UserController.swift
//  Random Users
//
//  Created by Carolyn Lea on 9/7/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation

class UserController
{
    let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!

    func getUsers(completion: @escaping ([User]?, Error?) -> Void)
    {
        var request = URLRequest(url: baseURL)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error
            {
                NSLog("error fetching users from server \(error)")
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                
                NSLog("Error fetching data. No data returned")
                completion(nil, NSError())
                return
            }
            
            do
            {
                let jsonDecoder = JSONDecoder()
                let results = try jsonDecoder.decode(Users.self, from: data)
                let users = results.results
                completion(users, nil)
            }
            catch
            {
                NSLog("Unable to decode data into user: \(error)")
                completion(nil, error)
                return
            }
            
        }
        .resume()
    }
    
    
    
    
///////end
}
