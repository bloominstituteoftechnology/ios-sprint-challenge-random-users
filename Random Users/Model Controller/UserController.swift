//
//  UserController.swift
//  Random Users
//
//  Created by Michael Flowers on 6/21/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

class UserController {
    
    static var shared = UserController()
    var users = [User]()
    
    typealias CompletionHandler = (Error?) -> Void
    private let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
    func fetchUsers(completion: @escaping CompletionHandler = { _ in }){
        URLSession.shared.dataTask(with: baseURL) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                print("Response status code for fetching: \(response.statusCode)")
            }
            if let error = error {
                print("Error with fetching network call: \(error.localizedDescription), detailed description: \(error)")
                completion(error)
                return
            }
            guard let data = data else { print("Error unwrapping data in fetch network call"); completion(NSError()); return }
            let jsonDecoder = JSONDecoder()
            do {
                let users = try jsonDecoder.decode(RandomUser.self, from: data).results.compactMap { $0 }
                self.users = users
                
            } catch {
                print("Error decoding person from server: \(error.localizedDescription), better description: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
}
