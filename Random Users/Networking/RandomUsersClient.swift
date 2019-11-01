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

enum NetworkingError: Error {
    case noData
    case noBearer
    case serverError(Error)
    case unexpectedStatusCode
    case badDecode
    case badEncode
    case fetchError
}

class RandomUsersClient {
    
    private let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,dob,picture&noinfo&results=1001")!
    
    var savedUsers: [Users] = []
    
    func fetchUsers(completion: @escaping (NetworkingError?) -> Void) {
        
        URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
            
            if let error = error {
                NSLog("Error with fetch: \(error)")
                completion(.fetchError)
                return
            }
            
            guard let data = data else {
                NSLog("Error with data")
                completion(.noData)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(RandomUsers.self, from: data)
                self.savedUsers = result.results
            } catch {
                NSLog("Error decoding users: \(error)")
            }
            completion(nil)
        }.resume()
    }
}
