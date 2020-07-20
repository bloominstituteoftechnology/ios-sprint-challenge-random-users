//
//  RandomUserController.swift
//  Random Users
//
//  Created by David Williams on 7/19/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

class RandomUserController {
    
    var users: [Users] = []
    
    let baseURL = URL(string: " https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    
    enum NetworkError: Error {
        case noData
        case decodeFailed
    }
    
    func getUSers(completion: @escaping (Result<[Users], NetworkError>) -> Void) {
       
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
                    let user = try jsonDecoder.decode([Users].self, from: data)
                    completion(.success(user))
                } catch {
                    NSLog("Error decoding user from server: \(error)")
                    completion(.failure(.decodeFailed))
                }
                return
            }
        }.resume()
    }
    
    func fetchImage(at urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            let image = UIImage(data: data)
            completion(image)
        }.resume()
    }
}
