//
//  NetworkController.swift
//  Random Users
//
//  Created by Stephanie Bowles on 8/15/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation


class NetworkController {
    
    var users: [User] = []
    
    let baseURL = URL(string: "https://randomuser.me/api/")!
    
    func fetchUsers(completion: @escaping (Error?) -> Void = {_ in}) {
        
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        
        let formatValue = URLQueryItem(name: "format", value: "json")
        
        let incReq = URLQueryItem(name: "inc", value: "name, email, phone, picture")
        
        let resultsReq = URLQueryItem(name: "results", value: "1000")
        
        urlComponents?.queryItems = [ formatValue, incReq, resultsReq]
        guard let requestURL = urlComponents?.url else {NSLog("Error connecting");
            completion(NSError()); return}
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching data")
                completion(error)
                return
            }
            guard let data = data else {
                NSLog("data not fetched")
                completion(NSError())
                return
            }
            let jsonDecoder = JSONDecoder()
            do {
                let users = try jsonDecoder.decode(Users.self, from: data)
                self.users = users.results
                completion(nil)
            } catch {
                NSLog("Unable to decode data")
                completion(error)
                return
            }
        }.resume()
    }
}
