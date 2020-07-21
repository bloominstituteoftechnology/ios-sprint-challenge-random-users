//
//  UserController.swift
//  Random Users
//
//  Created by Elizabeth Thomas on 5/15/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

enum NetworkError: Error {
    case loadFailed
    case decodeFailed
    case noData
    case noImage
}

class UserController {
    
    var results: [User] = []
    
    private let baseURL = URL(string: "https://randomuser.me/api/?results=5000")!
    
    func fetchUsers(completion: @escaping (Result<[String], NetworkError>) -> Void) {
        
        var request = URLRequest(url: baseURL)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard error == nil else {
                print("Error fetching users: \(error)")
                completion(.failure(.loadFailed))
                return
            }
            
            guard let data = data else {
                print("Error with data: \(error)")
                completion(.failure(.noData))
                return
            }
            
            let jsonDecoder = JSONDecoder()
            do {
                let user = try jsonDecoder.decode([String].self, from: data)
                completion(.success(user))
            } catch {
                print("Error decoding user object: \(error)")
                completion(.failure(.decodeFailed))
            }
        }
        task.resume()
    }
    
    func fetchImage(at urlString: String, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {

        let imageURL = URL(string: urlString)!

        var request = URLRequest(url: imageURL)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard error == nil else {
                print("Error fetching image: \(error)")
                completion(.failure(.noImage))
                return
            }

            guard let data = data else {
                print("Error with data: \(error)")
                completion(.failure(.noData))
                return
            }

            let image = UIImage(data: data)!
            completion(.success(image))
        }
        task.resume()
    }
}
