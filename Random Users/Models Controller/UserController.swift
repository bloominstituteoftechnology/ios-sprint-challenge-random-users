//
//  UserController.swift
//  Random Users
//
//  Created by Sammy Alvarado on 1/14/21.
//  Copyright © 2021 Erica Sadun. All rights reserved.
//

import UIKit

class UserController {
    
    var myUser: User?
    
    enum HTTPMethod: String {
        case get = "GET"
    }

    enum NetworkError: Error {
        case tryAgain
        case noData
        case noURL
    }

    private let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!

    func fetchUsers(completion: @escaping (Result<User, NetworkError>) -> Void) {
        var request = URLRequest(url: baseURL)
        request.httpMethod = HTTPMethod.get.rawValue

        let task = URLSession.shared.dataTask(with: request) { data, _, error in

            if let error = error {
                print("Error occurred fetching Users Detail data: \(error)")
                completion(.failure(.tryAgain))
                return
            }

            guard let data = data else {
                print("No data was recieved to for the User detail views")
                completion(.failure(.noData))
                return
            }

            do {
                let jsonDecoder = JSONDecoder()
                self.myUser = try jsonDecoder.decode(User.self, from: data)
//                self.allUsers = users.results
                completion(.success(self.myUser!))
            } catch {
                print("An error occurred when decoiding User Detail data: \(error)")
                completion(.failure(.tryAgain))
            }
        }
        task.resume()
    }

    func fetchUserImage(at urlString: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        let image = URL(string: urlString)!
        var request = URLRequest(url: image)
        request.httpMethod = HTTPMethod.get.rawValue

        let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error failed retreiving user image: \(urlString), error: \(error)")
            }

            guard let data = data else {
                completion(.failure(.noData))
                return
            }

//            let image = UIImage(data: data)!
            completion(.success(data))
        }
        task.resume()
    }
    
    
    
    
    
}
