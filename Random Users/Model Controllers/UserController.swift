//
//  UserController.swift
//  Random Users
//
//  Created by Lambda_School_Loaner_204 on 12/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

let baseURL = URL(string: "https://randomuser.me/api/")!

class UserController {
    
    //var results = Results()
    
    func fetchRandomUsers() {
        getRandomUsers(amount: 10) { (results: Results?, error) in
            guard let _ = results else {
                return
            }
            print("Decoded complete")
        }
    }
    
    private func getRandomUsers<T: Codable>(amount num: Int, completion: @escaping (T?, Error?) -> Void) {
        
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = [
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "inc", value: "name,email,phone,picture"),
            URLQueryItem(name: "results", value: String(num))
        ]

        guard let requestURL = urlComponents?.url else {
            print("Request URL is nil")
            completion(nil, NSError())
            return
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "content-type")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            
            if let error = error {
                print(error)
                completion(nil, error)
                return
            }
            
            guard let data = data else { return }
            
            
            do {
                let jsonDecoder = JSONDecoder()
                let decodedObjects = try jsonDecoder.decode(T.self, from: data)
                completion(decodedObjects, nil)
            } catch {
                print("Error decoding users")
                completion(nil, error)
                return
            }
            
        }.resume()
    }
}
