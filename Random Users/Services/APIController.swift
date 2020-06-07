//
//  APIController.swift
//  Random Users
//
//  Created by Cody Morley on 6/5/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class APIController {
    //MARK: - Types -
    enum HTTPMethod: String {
        case get = "GET"
    }
    
    enum NetworkError: Error {
        case badResponse
        case noData
        case noDecode
        case otherError
    }
    
    typealias UsersCompletionHandler = (Result<[User], NetworkError>) -> Void
    
    
    //MARK: - Properties -
    private let fetchURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
    lazy var decoder = JSONDecoder()
    
    
    //MARK: - Actions -
    func getUsers(completion: @escaping UsersCompletionHandler) {
        var request = URLRequest(url: fetchURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                NSLog("Something went wrong processing your fetch request: \(error.localizedDescription) \(error)")
                completion(.failure(.otherError))
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from fetch request.")
                completion(.failure(.noData))
                return
            }
            
            do {
                var users: [User] = []
                let results = try self.decoder.decode(UserBlock.self, from: data)
                users = results.results
                completion(.success(users))
            } catch {
                NSLog("Error decoding users: \(error) \(error.localizedDescription)")
                completion(.failure(.noDecode))
                return
            }
        }.resume()
    }
    
    
}
