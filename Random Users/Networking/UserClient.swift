//
//  UserClient.swift
//  Random Users
//
//  Created by Lydia Zhang on 4/10/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation


let baseURL = URL(string: "https://randomuser.me/api/")!
class UserClient {
    
    var users: [User] = []
    
    func fetchUser(completion: @escaping (Error?) -> ()) {
        
        let jsonQueryItem = URLQueryItem(name: "format", value: "json")
        let incItem = URLQueryItem(name:"inc",value: "name,email,phone,picture")
        let resultItem = URLQueryItem(name: "results", value: "100")
        var urlComponent = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        
        urlComponent?.queryItems = [jsonQueryItem, incItem, resultItem]
        
        guard let requestURL = urlComponent?.url else {
            NSLog("URL doesnt exist")
            return
        }
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {(data, _ , error) in
            if let error = error {
                NSLog("Error fetching")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data when fetching")
                return
            }
            do {
                let result = try JSONDecoder().decode(Users.self, from: data)
                self.users = result.results
                completion(nil)
            } catch {
                NSLog("Error decoding")
                completion(error)
                return
            }
            
        }.resume()
    }
    
    
}
