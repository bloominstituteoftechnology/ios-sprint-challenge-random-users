//
//  UserController.swift
//  Random Users
//
//  Created by Lambda_School_Loaner_241 on 5/15/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")

class UserController {
    var savedUser: [User] = []
    
    func addUser(user: User) {
        savedUser.append(user)
    }
    
    func removeUser(user: User){
        guard let index = savedUser.firstIndex(of: user) else { return }
        
        savedUser.remove(at: index)
        
        
    }
    
    func fetchUser(completion: @escaping (Result<User, Error>)->Void){
        guard let requestURL = baseURL else { return }
        
        URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
            if let error = error {
                print("Error fetching user")
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError()))
                return
            }
            do {
                let decoder = JSONDecoder()
                
                let userData = try decoder.decode(User.self, from: data)
                completion(.success(userData))
            } catch {
                NSLog("Error decoding data to type User: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchImage(at urlString: String, completion: @escaping (UIImage?)->Void){
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching image: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from data task")
                completion(nil)
                return
            }
            
            let image = UIImage(data: data)
            completion(image)
        }.resume()
        
        
        // Getting the image
    }
    
}


// Redo
