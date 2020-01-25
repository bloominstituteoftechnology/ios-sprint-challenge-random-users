//
//  APIController.swift
//  Random Users
//
//  Created by Joe on 1/25/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class APIController {
    
    var users: [RandomUsers] = []
    
    let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!

    func getRandomUsers(completion: @escaping () -> Void = { }) {
        
        var request = URLRequest(url: baseURL)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error during dataTask: \(error)")
                completion()
                
                return
            }
            
            guard let data = data else {
                print("There was an error retrieving data")
                completion()
                return
            }
            
            let decoder = JSONDecoder()
            do {
            let users = try decoder.decode([RandomUsers].self, from: data)
            self.users = users
            completion()
            } catch {
                print("error completing task")
            }
            
        }.resume()
        
    }
    
    
    
}
