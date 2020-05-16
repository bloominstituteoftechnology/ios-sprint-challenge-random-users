//
//  UserController.swift
//  Random Users
//
//  Created by Elizabeth Thomas on 5/15/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

class UserController {
    
    var results: [User] = []
    
    private let baseURL = URL(string: "https://randomuser.me/api/?results=5000")!
    
    func fetchUsers(numberOfUsers: Int = 1000, using session: URLSession = URLSession.shared,completion: @escaping ([User]?, Error?) -> Void) {
        
        let userURL = URL(string: "https://randomuser.me/api/?results=\(numberOfUsers)&inc=name,email,phone,picture&format=json")!
        
        fetch(from: userURL) { (users: UserResults?, error: Error?) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let users = users?.results else {
                completion(nil, error)
                return
            }
            completion(users, nil)
        }
    }
    
    func fetchImage(at imageURL: URL, using session: URLSession = URLSession.shared, completion: @escaping (UIImage?, Error?) -> Void) {

        fetch(from: imageURL) { (data: Data?, error: Error?) in
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil, error)
                return
            }
            completion(image, nil)
        }
    }
    
    private func fetch<T: Codable>(from url: URL, using session: URLSession = URLSession.shared, completion: @escaping (T?, Error?) -> Void) {
        session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "com.LambdaSchool.RandomUsers.ErrorDomain", code: -1, userInfo: nil))
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
}
