//
//  API.swift
//  Random Users
//
//  Created by brian vilchez on 10/4/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation
enum NetworkError: Error {
    case error
}

class API {
    private(set) var users = [User]()
    
    func getUsersFromServer(completion: (NetworkError?) -> Void) {
        guard let userURL = URL(string: "https:randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")
            else {return}
        var request = URLRequest(url: userURL)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {(data,response,error) in
            guard let response = response as? HTTPURLResponse,
                response.statusCode == 201 else {return}
            guard let data = data else {return}
            
            if let error = error {
                print("could get user from server: \(error)")
                return
            }
            
            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                    self.users.append(user)
                } catch let error {
                    print("Error decoding user: \(error)")
                    return
                         }
            
        }.resume()
    }
}
