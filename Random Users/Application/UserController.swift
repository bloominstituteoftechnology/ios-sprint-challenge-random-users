//
//  UserController.swift
//  Random Users
//
//  Created by Bobby Keffury on 11/9/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

enum HTTPMethod: String {
    case get = "GET"
}

enum NetworkError: Error {
    case badData
    case otherError
    case noDecode
}

class UserController {
    
    
    private let baseUrl = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
    func searchForUsers(completion: @escaping (Result<Results, NetworkError>) -> Void) {
        
        var request = URLRequest(url: baseUrl)
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let _ = error {
                completion(.failure(.otherError))
                return
            }
            
            guard let data = data else { return }
            
            let decoder = JSONDecoder()
            
            do {
                let results = try decoder.decode(Results.self, from: data)
                completion(.success(results))
                
            } catch {
                print("Error decoding User object: \(error)")
                completion(.failure(.noDecode))
                return
            }
            
            
        }.resume()
    }
    
    
    
}

