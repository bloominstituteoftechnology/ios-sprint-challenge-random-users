//
//  NetworkingController.swift
//  Random Users
//
//  Created by John McCants on 9/11/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class NetworkingController {
    
var contacts: Contacts?
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
    
    func getContacts(completion: @escaping (Result<Contacts, NetworkError>) -> Void) {
        var request = URLRequest(url: baseURL)
        request.httpMethod = URLMethods.get.rawValue
        
        let task = URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
            if let error = error {
                completion(.failure(.downloadError))
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                print("Error getting Contact Data")
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                self.contacts = try jsonDecoder.decode(Contacts.self, from: data)
                completion(.success(self.contacts!))
            } catch {
                print("Error decoding JSON")
                completion(.failure(.decodeFailed))
            }
            
        }
        task.resume()
        
    }
    
    func getImage(_ urlString: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = URLMethods.get.rawValue
        
        let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                completion(.failure(.downloadError))
                print("Error: \(error.localizedDescription)")
            }
            
            guard let imageData = data else {
                completion(.failure(.noImageData))
                print("Error fetching image data")
                return
            }
            
            completion(.success(imageData))
            
        }
        task.resume()
    }

}
