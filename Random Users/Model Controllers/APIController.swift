//
//  APIController.swift
//  Random Users
//
//  Created by Jon Bash on 2019-12-06.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class APIController {
    let baseURL = URL(string: "https://randomuser.me/api/")!
    let defaultQuery = "?format=json&inc=name,email,phone,picture&results=1000"
    lazy var defaultURL: URL = {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        components?.queryItems = [
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "inc", value: "name,email,phone,picture"),
            URLQueryItem(name: "results", value: "1000")
        ]
        return components?.url ?? baseURL
    }()
    
    func fetchUsers(completion: @escaping (Result<[RandomUser], Error>) -> ()) {
        var request = URLRequest(url: defaultURL)
        print(defaultURL)
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) {
            data, response, error in
            
            if let error = error {
                print("ERROR FETCHING USERS\nERROR:\n\(error)")
                if let response = response {
                    print("RESPONSE:\n\(response)")
                }
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                print("ERROR FETCHING USERS\nNO DATA")
                completion(.failure(NSError()))
                return
            }
            
            do {
                let results = try JSONDecoder().decode(RandomUserAPIResults.self, from: data)
                completion(.success(results.users))
            } catch {
                print("ERROR DECODING FETCHED USERS\nERROR:\n\(error)")
                if let rawData = String(data: data, encoding: .utf8) {
                    print("DATA:\n\(rawData)")
                }
                completion(.failure(error))
            }
        }
        dataTask.resume()
    }
}
