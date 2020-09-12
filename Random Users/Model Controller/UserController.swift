//
//  UserController.swift
//  Random Users
//
//  Created by Norlan Tibanear on 9/11/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserController {
    
    var myUser: UserResult?
    
    enum NetworkError: Error {
        case noData
        case decodeFailed
        case noImage
        case noConnection
    }
    
    
    // baseURL
    private let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
    
    func getUsers(completion: @escaping (Result<UserResult, NetworkError>) -> Void) {
        
        var request = URLRequest(url: baseURL)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print("Error getting users: \(error)")
                completion(.failure(.noData))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                response.statusCode == 200 else {
                    completion(.failure(.noConnection))
                    return
            }
            
            guard let data = data else { return }
            
            do {
                let jsonDecoder = JSONDecoder()
                self.myUser = try jsonDecoder.decode(UserResult.self, from: data)
                completion(.success(self.myUser!))
            } catch {
                print("Failed decoding JSON: \(error)")
                completion(.failure(.decodeFailed))
            }
        }
        task.resume()
        
    }//
    
    
    func getUserImage(path: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        
        var request = URLRequest(url: URL(string: path)!)
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                print("Error loading Image: \(error)")
                completion(.failure(.noImage))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            completion(.success(data))
            
        }
        dataTask.resume()
        
    }//
    
    
    
    
} // Class
