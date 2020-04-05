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
    var userResults: [User] = []
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
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard error == nil {
                print("Error fetching data: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                print("No data returned from the data task.")
                completion(NSError())
                return
            }
            
            do {
                self.userResults = try JSONDecoder().decode([User].self, from: data)
//                self.userResults.append(decodedUser)
                completion(nil)
            } catch {
                print("Unable to decode data into user objects: \(error)")
                completion(error)
            }
        }.resume()
    }
}
