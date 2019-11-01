//
//  RandomPersonController.swift
//  Random Users
//
//  Created by Gi Pyo Kim on 11/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//
enum HTTPMethod: String {
    case get = "GET"

}

enum NetworkError: Error {
    case fetchingError
    case noData
    case badDecode
}

import Foundation

class RandomPersonController {
    
    let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
    
    func fetchRandomPeople (completion: @escaping (RandomPerson?,NetworkError?) -> Void) {
        var requestURL = URLRequest(url: baseURL)
        requestURL.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: requestURL, completionHandler: { (data, _, error) in
            if let error = error {
                NSLog("Error fetching random people: \(error)")
                completion(nil,.fetchingError)
                return
            }
            
            guard let data = data else {
                NSLog("Invalid Data")
                completion(nil, .noData)
                return
            }
            
            do {
                let randomPerson = try JSONDecoder().decode(RandomPerson.self, from: data)
                completion(randomPerson,nil)
            } catch {
                NSLog("Error decoding data: \(error)")
                completion(nil, .badDecode)
                return
            }
        }).resume()
    }
}
