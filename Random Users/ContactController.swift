//
//  ContactController.swift
//  Random Users
//
//  Created by Kenneth Jones on 7/21/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class ContactController {
    enum HTTPMethod: String {
        case get = "GET"
    }

    enum NetworkError: Error {
        case noData
        case tryAgain
        case networkFailure
    }

    private let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
    var results: [Contact] = []
    
    func fetchContacts(completion: @escaping (Result<[Contact], NetworkError>) -> Void) {
        var request = URLRequest(url: baseURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error receiving contact data: \(error)")
                completion(.failure(.tryAgain))
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.failure(.networkFailure))
                return
            }
            
            guard let data = data else {
                print("No data received from fetchContacts")
                completion(.failure(.noData))
                return
            }
            
            DispatchQueue.main.async {
                do {
                    let decoder = JSONDecoder()
                    let contacts = try decoder.decode([Contact].self, from: data)
                    self.results = contacts
                    completion(.success(contacts))
                } catch {
                    print("Error decoding contact data: \(error)")
                    completion(.failure(.tryAgain))
                    return
                }
            }
        }
        task.resume()
    }
}
