//
//  APIController.swift
//  Random Users
//
//  Created by Josh Kocsis on 7/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

final class APIController {
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }

    enum NetworkError: Error {
        case noData
        case noURL
        case decodingError
    }

    var user: [User] = []
    private let baseURL = URL(string: "https://randomuser.me/api")!

    func fetchUsers(completion: @escaping (Result<Bool, NetworkError>) -> Void) {

        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let jsonQureyItem = URLQueryItem(name: "format", value: "json")
        let queryItem = URLQueryItem(name: "inc", value: "name, email, phone, picture")
        let queryItem1 = URLQueryItem(name: "results", value: "5000")

        urlComponents?.queryItems = [jsonQureyItem, queryItem, queryItem1]

        guard let requestURL = urlComponents?.url else {
            print("Error getting request url")
            completion(.failure(.noURL))
            return
        }

        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue

        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error getting users: \(error)")
                completion(.failure(.noData))
                return
            }

            guard let data = data else {
                print("Error getting data: \(String(describing: error))")
                completion(.failure(.noData))
                return
            }

            do {
                let results = try JSONDecoder().decode(Users.self, from: data)
                self.user = results.results
                completion(.success(true))
            } catch {
                NSLog("Error decoding results: \(error)")
                completion(.failure(.decodingError))
            }
        } .resume()
    }
}
