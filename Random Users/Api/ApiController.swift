//
//  ApiController.swift
//  Random Users
//
//  Created by scott harris on 3/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case nodata
    case badURL
    case noDecode
    case networkError
    case badResponseCode
}


class ApiController {
    let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
    func fetchContacts(completion: @escaping (Result<[Contact], NetworkError>) -> Void) {
        let request = URLRequest(url: baseURL)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Network Error: \(error)")
                completion(.failure(.networkError))
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                NSLog("Unsuccessful network response code, Reponse Code was: \(response.statusCode)")
                completion(.failure(.badResponseCode))
                return
            }
            
            guard let data = data else {
                NSLog("No data received form api")
                completion(.failure(.nodata))
                return
            }
            
            let jsonDecoder = JSONDecoder()
            do {
                let contacts = try jsonDecoder.decode(ContactResults.self, from: data)
                
                completion(.success(contacts.results))
            } catch {
                NSLog("Error Decoding Contacts. Error: \(error)")
                completion(.failure(.noDecode))
            }
            
            
        }.resume()
        
    }
    
}
