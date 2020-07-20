//
//  RandomUserController.swift
//  Random Users
//
//  Created by David Williams on 7/19/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class RandomUserController {
    
    let baseURL = URL(string: " https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    
    enum NetworkError: Error {
        case noData
        case decodeFailed
    }
    
    func getUSers(completion: @escaping (Result<Users, NetworkError>) -> Void) {
       
        let requestURL = baseURL.appendingPathComponent("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error getting info from server: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                
                guard let data = data else {
                    completion(.failure(.noData))
                    return
                }
                let jsonDecoder = JSONDecoder()
                
                do {
                    let user = try jsonDecoder.decode(Users.self, from: data)
                    completion(.success(user))
                } catch {
                    NSLog("Error decoding user from server: \(error)")
                    completion(.failure(.decodeFailed))
                }
                return
            }
        }.resume()
        
    }
}
