//
//  UserController.swift
//  Random Users
//
//  Created by Jessie Ann Griffin on 3/20/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class UserController {
    
    var randomUserAPIURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")
//    var userResults: [User] = []
    //let dataFromURL: Data = try! Data(contentsOf: randomUserAPIURL!)
//
//    var urlComponents = URLComponents()
//    urlComponents.scheme = "https"
//    urlComponents.host = "itunes.apple.com"
//    urlComponents.path = "/search"
//    let searchTermQueryItem = URLQueryItem(name: "term", value: searchTerm)
//    let entityItem = URLQueryItem(name: "entity", value: resultType.rawValue)
//    urlComponents.queryItems = [searchTermQueryItem, entityItem]
//    print(urlComponents)
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
}
