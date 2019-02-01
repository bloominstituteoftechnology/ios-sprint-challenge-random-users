//
//  RandomUserNetworkController.swift
//  Random Users
//
//  Created by Sergey Osipyan on 2/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class RandomUserController {
    
    var users: [RandomUsersModel] = []
    typealias ComplitionHandler = (Error?) -> Void
    let baseURL: URL = URL(string: "https:randomuser.me/api/?format=json&inc=name,email,phone,picture&results=10")! // 10 for test
    
    func getRandomUsers(complition: @escaping  ComplitionHandler = { _ in }) {
        
        URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching users \(error)")
                complition( error)
                return
            }
            guard let data = data else {
                NSLog("No data")
                complition(NSError())
                return
            }
            
            do {
                let usersResualt = try JSONDecoder().decode(RandomUsersModel.self, from: data)
                self.users = [usersResualt]
                
                print(self.users)
            } catch {
                
                NSLog("Error")
                complition(error)
            }
            
            }.resume()
    }
}

