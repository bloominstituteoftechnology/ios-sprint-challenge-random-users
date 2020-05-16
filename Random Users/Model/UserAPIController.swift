//
//  UserAPIController.swift
//  Random Users
//
//  Created by Chad Parker on 5/15/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case otherError(Error)
    case noData
    case decodeError
}

class UserAPIController {
    
    let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
    func getUsers(completion: @escaping (Result<[User], NetworkError>) -> Void) {
        
        URLSession.shared.dataTask(with: baseURL) { data, _, error in
            guard error == nil else {
                completion(.failure(.otherError(error!)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let usersResult = try JSONDecoder().decode(UserResult.self, from: data)
                let users = usersResult.users
                completion(.success(users))
            } catch {
                NSLog("Error decoding entry representations: \(error)")
                completion(.failure(.decodeError))
            }
        }.resume()
    }
}
