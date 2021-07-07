//
//  ModelClient.swift
//  Random Users
//
//  Created by Moses Robinson on 2/22/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

private let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture")!

class ModelClient {
    
    func fetchUsers(resultsNumber: String, completion: @escaping (Error?) -> Void = { _ in }) {
        
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let queryItem = URLQueryItem(name: "results", value: resultsNumber)
        urlComponents?.queryItems = [queryItem]
        
        guard let requestURL = urlComponents?.url else {
            NSLog("No URL found.")
            completion(NSError())
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                NSLog("could not find data: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("Could not find data. No data returned.")
                completion(error)
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                
                let decodedUsers = try jsonDecoder.decode(Users.self, from: data)
                self.users = decodedUsers.results
                completion(nil)
            } catch {
                NSLog("Unable to decode data into result: \(error)")
                completion(error)
                return
            }
        }
        dataTask.resume()
    }
    
    // MARK: - Properties
    
    private(set) var users: [User] = []
}
