//
//  RandomUsersClient.swift
//  Random Users
//
//  Created by Jesse Ruiz on 11/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

class RandomUsersClient {
    
    private let baseURL = URL(string: "https://randomuser.me/api/?results=10")!
    
    var savedUsers: [RandomUsers] = []
    
    func fetchUsers(completion: @escaping () -> Void) {
        
        var request = URLRequest(url: baseURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion()
                return
            }
            
            if let _ = error {
                completion()
                return
            }
            
            guard let data = data else {
                completion()
                return
            }
            
            do {
                self.savedUsers = try JSONDecoder().decode([RandomUsers].self, from: data)
                completion()
            } catch {
                NSLog("Error: \(error)")
                completion()
                return
            }
        }.resume()
    }
    
    func fetchImage(at url: URL, completion: @escaping (UIImage?) -> Void) {
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            
            if let error = error {
                NSLog("Error fetching images: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from image fetch data task")
                completion(nil)
                return
            }
            
            let image = UIImage(data: data)
            completion(image)
        }
    }
}
