//
//  RandomUserClient.swift
//  Random Users
//
//  Created by Shawn Gee on 4/10/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct User: Codable {
//    let name: Name
    let email: String
//    let phone: String
//    let picture: Picture
}

struct Name: Codable {
    let title: String
    let first: String
    let last: String
}

struct Picture: Codable {
    let large: URL
    let medium: URL
    let thumbnail: URL
}

enum NetworkError: Error {
    case clientError(Error)
    case invalidResponseCode(Int)
    case noData
    case decodingError(Error)
    case encodingError(Error)
    case invalidData
}

class RandomUserClient {
    let url = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
    func fetchUsers(completion: @escaping (Result<[User], NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.clientError(error)))
                return
            }
            
            if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                completion(.failure(.invalidResponseCode(response.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let json = try JSONDecoder().decode([String: [User]].self, from: data)
                guard let users = json["results"] else { throw NSError(domain: "No value in json dict for results key", code: 1) }
                completion(.success(users))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }
}
