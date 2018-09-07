//
//  UserController.swift
//  Random Users
//
//  Created by Andrew Liao on 9/7/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

private let queryURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!

class UserClient{
    static let shared = UserClient()
    
    func fetchUserData(completion: @escaping ([User]) -> Void){
        var userData = [User]()
        
        URLSession.shared.dataTask(with: queryURL) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching user data: \(error)")
            }
            guard let data = data else {
                NSLog("Data is nil")
                return
            }
            do{
                let decodedData = try JSONDecoder().decode(UserResults.self, from: data)
                
                for representation in decodedData.results{
                    userData.append(User(userRepresentation: representation))
                }
            } catch {
                NSLog("Error decoding: \(error)")
            }
            completion(userData)
            }.resume()
        
    }
    
}
