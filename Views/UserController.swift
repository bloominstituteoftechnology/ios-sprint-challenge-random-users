//
//  UserController.swift
//  Random Users
//
//  Created by Ian French on 7/19/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

class RandomUsersController {

    var randomUser: RandomUsersResults?
    let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!

    enum NetworkError: Error {
        case miscError
        case noData
        case noDecode
        case failedDecode
    }


    func getUsers(completion: @escaping (Result<RandomUsersResults, NetworkError>) -> Void) {

        var request = URLRequest(url: baseURL)
        request.httpMethod = "GET"

        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard error == nil else {
                completion(.failure(.miscError))
                return
            }

            guard let data = data else {
                completion(.failure(.noData))
                return
            }

            let decoder = JSONDecoder()
            do {
                self.randomUser = try decoder.decode(RandomUsersResults.self, from: data)
                completion(.success(self.randomUser!))

            } catch {
                completion(.failure(.failedDecode))
                return
            }
        }

        dataTask.resume()
    }


    func getUserImage(path: String, completion: @escaping(Result<Data, NetworkError>) -> Void ) {
        var request = URLRequest(url: URL(string: path)!)
        request.httpMethod = "GET"

        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard error == nil else {
                completion(.failure(.miscError))
                return
            }

            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            completion(.success(data))
        }

        dataTask.resume()
    }
}
