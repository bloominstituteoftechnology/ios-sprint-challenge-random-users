//
//  APIController.swift
//  Random Users
//
//  Created by Bronson Mullens on 7/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class APIController {
    
    // MARK: - Properties
    
    var myContacts: Contacts?
    let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
    enum URLMethods: String {
        case get = "GET"
    
    }
    enum NetworkError: Error {
        case noData
        case noImageData
        case decodeFailed
        case downloadError
    }
    
    // MARK: - Network Functions
    
    func fetchContacts(completion: @escaping (Result<Contacts, NetworkError>) -> Void) {
        var request = URLRequest(url: baseURL)
        request.httpMethod = URLMethods.get.rawValue
        
        let task = URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
            if let downloadError = error {
                completion(.failure(.downloadError))
                NSLog("Error: \(downloadError.localizedDescription)")
                return
            }
            
            guard let contactData = data else {
                completion(.failure(.noData))
                NSLog("Error fetching contact data")
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                self.myContacts = try jsonDecoder.decode(Contacts.self, from: contactData)
                completion(.success(self.myContacts!))
            } catch {
                NSLog("Error decoding JSON")
                completion(.failure(.decodeFailed))
            }
            
        }
        task.resume()
        
    }
    
    func fetchImage(_ urlString: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = URLMethods.get.rawValue
        
        let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let imageError = error {
                completion(.failure(.downloadError))
                NSLog("Error: \(imageError.localizedDescription)")
            }
            
            guard let imageData = data else {
                completion(.failure(.noImageData))
                NSLog("Error fetching image data")
                return
            }
            
            completion(.success(imageData))
            
        }
        task.resume()
    }
    
}
