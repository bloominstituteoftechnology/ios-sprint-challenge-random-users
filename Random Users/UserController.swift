//
//  UserController.swift
//  Random Users
//
//  Created by Andrew Liao on 9/7/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

private let queryURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!

class UserController{
    func fetchUsers(){
        URLSession.shared.dataTask(with: queryURL) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching user data: \(error)")
            }
            guard let data = data else {
                NSLog("Data is nil")
                return
            }
            do{
                let decodedData = try JSONDecoder().decode(UserData.self, from: data)
                
                for representation in decodedData.results{
                    self.userData.append(User(userRepresentation: representation))
                }
            } catch {
                NSLog("Error decoding: \(error)")
            }
            }.resume()
        
    }
    
    private(set) var userData = [User]()
}
