//
//  RandomUsersController.swift
//  Random Users
//
//  Created by Claudia Contreras on 5/15/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

class RandomUsersController {
    // MARK: - Properties
    
    var randomUsers: RandomUsersResults?
    let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
    enum NetworkError: Error {
        case noAuth
        case unauthorized
        case otherEror(Error)
        case noData
        case decodeFailed
    }
    
    // MARK: - Functions
    
    // Get the users
    func getUsers(completion: @escaping (Result<RandomUsersResults, NetworkError>) -> Void) {
        var request = URLRequest(url: baseURL)
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard error == nil else {
                completion(.failure(.otherEror(error!)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                self.randomUsers = try decoder.decode(RandomUsersResults.self, from: data)
                completion(.success(self.randomUsers!))
            } catch {
                completion(.failure(.decodeFailed))
                return
            }
        }
        dataTask.resume()
    }
    
    // Get the image
    func downloadUserImage(path: String, completion: @escaping(Result<Data, NetworkError>) -> Void ) {
        var request = URLRequest(url: URL(string: path)!)
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard error == nil else {
                completion(.failure(.otherEror(error!)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            completion(.success(data))
        }
        
        dataTask.resume()
    }
}
