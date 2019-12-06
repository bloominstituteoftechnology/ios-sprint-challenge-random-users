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
    lazy var defaultURL = baseURL.appendingPathComponent(defaultQuery)
    
    func fetchUsers(completion: @escaping (Result<[RandomUser], Error>) -> ()) {
        var request = URLRequest(url: defaultURL)
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
                let decoder = JSONDecoder()
                let container = decoder.decode(<#T##type: Decodable.Protocol##Decodable.Protocol#>, from: <#T##Data#>)
            } catch {
                print("ERROR DECODING FETCHED USERS\nERROR:\n\(error)")
                completion(.failure(error))
            }
        }
        dataTask.resume()
    }
}
