//
//  UserController.swift
//  Random Users
//
//  Created by Jessie Ann Griffin on 3/20/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserController {
    
    var randomUserAPIURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")
    let imageCache = NSCache<NSString, UIImage>()

    func fetchRandomUsers(completion: @escaping (Result<[User], NetworkError>) -> Void) {
        guard let requestUrl = randomUserAPIURL else {
            print("Request URL is nil.")
            return
        }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(.unableToComplete))
                }
                print("Error fetching data: \(String(describing: error))")
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                DispatchQueue.main.async {
                    completion(.failure(.invalidResponse))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                print("No data returned from the data task.")
                return
            }
            
            do {
                let user = try JSONDecoder().decode(UserResults.self, from: data).results
                DispatchQueue.main.async {
                    completion(.success(user))
                }
            } catch {
                completion(.failure(.decodeError))
                print("Unable to decode data into user objects: \(error)")
            }
        }.resume()
    }
    
    func fetchUser(for url: URL, completion: @escaping (Result<User, NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(.unableToComplete))
                }
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                DispatchQueue.main.async {
                    completion(.failure(.invalidResponse))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let user = try decoder.decode(User.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(user))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.decodeError))
                }
                return
            }
        }.resume()
    }
    
    func fetchImage(for url: URL, completion: @escaping (Result<UIImage, NetworkError>) -> ()) {
        
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            print("cached image")
            completion(.success(cachedImage))
        } else {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard error == nil else {
                    DispatchQueue.main.async {
                        completion(.failure(.unableToComplete))
                    }
                    return
                }
                
                if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                    DispatchQueue.main.async {
                        completion(.failure(.invalidResponse))
                    }
                    return
                }
                
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(.failure(.noData))
                    }
                    return
                }
                
                guard let image = UIImage(data: data) else {
                    DispatchQueue.main.async {
                        completion(.failure(.noImage))
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                    print("session image")
                    completion(.success(image))
                }
            }.resume()
        }
    }
}
