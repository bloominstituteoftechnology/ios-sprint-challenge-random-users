//
//  RandomUserClient.swift
//  Random Users
//
//  Created by Shawn Gee on 4/10/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

struct Wrapper: Decodable {
    let results: [User]
}

struct User: Decodable {
    let name: Name
    let email: String
    let phone: String
    let picture: Picture
}

struct Name: Decodable {
    let title: String
    let first: String
    let last: String
}

struct Picture: Decodable {
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
                let wrapper = try JSONDecoder().decode(Wrapper.self, from: data)
                let users = wrapper.results
                completion(.success(users))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }
}
