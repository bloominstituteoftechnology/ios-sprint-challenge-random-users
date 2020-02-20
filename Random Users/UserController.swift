//
//  UserController.swift
//  Random Users
//
//  Created by Jorge Alvarez on 2/14/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

// should be 1000 instead of 1 !!!
let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1")!

class UserController {
    
    typealias CompletionHandler = (Error?) -> Void
    /// Array that stores users
    var user: User?
    
    init() {
        print("init")
        getUsers()
    }
    
    private func fetch<T: Codable>(from url: URL,
                           using session: URLSession = URLSession.shared,
                           completion: @escaping (T?, Error?) -> Void) {
        session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "", code: -1, userInfo: nil))
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                let decodedObject = try jsonDecoder.decode(T.self, from: data)
                completion(decodedObject, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
    
    func fetchPhotos(session: URLSession = URLSession.shared,
                     completion: @escaping ([User]?, Error?) -> Void) {
        
        
        fetch(from: baseURL, using: session) { (dictionary: [String : [User]]?, error: Error?) in
            guard let photos = dictionary?["photos"] else {
                completion(nil, error)
                return
            }
            completion(photos, nil)
        }
    }
    
    /// Fetches users from API (decoding them) and appends them to self.userArray
    func getUsers(completion: @escaping CompletionHandler = { _ in }) {
        print("called getUsers")
        var request = URLRequest(url: baseURL)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print("Error occured in getUsers: \(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            
            guard let data = data else {
                print("No data returned")
                DispatchQueue.main.async {
                    completion(NSError())
                }
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let userResults = try decoder.decode(User.self, from: data)
                self.user = userResults
                print(self.user)
                //self.userArray.append(userResults)
                DispatchQueue.main.async {
                    completion(nil)
                }
                //completion(nil)
            } catch {
                print("Error decoding users in getUsers: \(error)")
                completion(nil)
            }
            
        }.resume()
    }
}
