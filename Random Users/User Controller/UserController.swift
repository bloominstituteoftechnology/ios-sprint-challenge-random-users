//
//  UserController.swift
//  Random Users
//
//  Created by Juan M Mariscal on 7/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

enum HTTPMethod: String {
    case get = "GET"
}

enum NetworkError: Error {
    case noAuth
    case unauthorized
    case otherError(Error)
    case noData
    case decodeFailed
    case encodedFailed
}

class UserController {
    var user: User?
    var userList: [User] = []
    
    private let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
    func fetchUsers(completion: @escaping (NetworkError?) -> Void) {
        var request = URLRequest(url: baseURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard error == nil else {
                completion((.otherError(error!)))
                return
            }
            
            guard let data = data else {
                completion((.noData))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let userNames = try decoder.decode(UserResults.self, from: data)
                self.userList.append(contentsOf: userNames.results)
                completion(nil)
            } catch {
                completion((.decodeFailed))
            }
        }.resume()
    }
    
    func fetchImage(at urlString: String, completion: @escaping (Result <UIImage, NetworkError>) -> Void) {
        let imageURL = URL(string: urlString)!
        var request = URLRequest(url: imageURL)
        request.httpMethod = HTTPMethod.get.rawValue
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard error == nil else {
                completion(.failure(.otherError(error!)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            if let image = UIImage(data: data) {
                completion(.success(image))
            } else {
                completion(.failure(.decodeFailed))
            }
        }.resume()
        
    }
    
}
