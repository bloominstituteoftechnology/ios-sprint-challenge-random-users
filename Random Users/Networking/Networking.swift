//
//  Networking.swift
//  Random Users
//
//  Created by Breena Greek on 5/15/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

enum NetworkError: Error {
    case otherError
    case noAuth
    case noDecode
    case noData
}

class Networking {
    
    var users: [User] = []
    
    let baseURL = URL(string: "https://randomuser.me/api/")!
    
    var jsonDecoder: JSONDecoder = {
          let decoder = JSONDecoder()
          decoder.keyDecodingStrategy = .convertFromSnakeCase
          return decoder
      }()
    
    func fetchUsers(completion: @escaping(Result<[User], NetworkError>) -> Void) {
        
        let components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
             guard let requestURL = components?.url else {
                 NSLog("Request URL is nil")
                 completion(.failure(.otherError))
                 return
             }
             var request = URLRequest(url: requestURL)
             request.httpMethod = HTTPMethod.get.rawValue
             URLSession.shared.dataTask(with: request) { (data, _, error) in
                 if let error = error {
                     print("Error fetching data \(error)")
                     completion(.failure(.noData))
                     return
                 }
                 guard let data = data else {
                     completion(.failure(.noData))
                     return
                 }
                 do {
                     let user = try self.jsonDecoder.decode([User].self, from: data)
                     self.users = user
                     completion(.success(user))
                 } catch {
                     NSLog("Error decoding data: \(error)")
                     completion(.failure(.noDecode))
                 }
             } .resume()
         }
    }
