//
//  RandomUserNetworkController.swift
//  Random Users
//
//  Created by Sergey Osipyan on 2/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class RandomUserController {
    
    var users: [RandomUser] = []
    typealias ComplitionHandler = (Error?) -> Void
    let baseURL: URL = URL(string: "https:randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
    func getRandomUsers(complition: @escaping  ComplitionHandler = { _ in }) {
        
        URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching users \(error)")
                complition(error)
                return
            }
            guard let data = data else {
                NSLog("No data")
                complition(NSError())
                return
            }
            
            do {
                let usersResualt = try JSONDecoder().decode(RandomUsersModel.self, from: data)
                self.users = usersResualt.results
                complition(nil)
                print(self.users)
            } catch {
                
                NSLog("Error")
                complition(error)
                return
            }
            
            }.resume()
    }
}

