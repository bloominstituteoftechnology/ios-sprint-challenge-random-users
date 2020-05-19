//
//  UserController.swift
//  Random Users
//
//  Created by patelpra on 5/16/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//
import Foundation
import UIKit

let baseURL = URL(string: "https://randomuser.me/api/")!

enum NetworkError: Error {
    case otherError
    case badData
}

class UserController {
    typealias CompletionHandler = (Error?) -> Void
    
    private (set) var users: [User] = []
        
    func fetchUsers(completion: @escaping CompletionHandler = { _ in }) {
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let jsonQueryItem = URLQueryItem(name: "format", value: "json")
        let incQueryItem = URLQueryItem(name: "inc", value: "name,email,phone,picture")
        let resultsQueryItem = URLQueryItem(name: "results", value: "5000")
        
        urlComponents?.queryItems = [jsonQueryItem, incQueryItem, resultsQueryItem]
        
        guard let requestURL = urlComponents?.url else { NSLog("requestURL is nil"); completion(NSError()); return }
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching data: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else { NSLog("No data returned from data task"); completion(NSError()); return }
            
            let jsonDecoder = JSONDecoder()
            do {
                let users = try jsonDecoder.decode(Users.self, from: data)
                self.users = users.results
                completion(nil)
            } catch {
                NSLog("Unable to decode data into object of type [User]: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
}
