//
//  APIController.swift
//  Random Users
//
//  Created by Clayton Watkins on 7/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class APIController{
    // MARK: - Properties
    var myContacts: ContactResults?
    private let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!

    enum NetworkError: Error{
        case noData
        case tryAgain
        case decodeFailed
        case noImage
        case noConnection
    }
    
    // MARK: - Network Functions
    // Getting randomly generated contacts from the API
    func getContacts(completion: @escaping (Result<ContactResults, NetworkError>) -> Void) {
        var request = URLRequest(url: baseURL)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error{
                completion(.failure(.tryAgain))
                print("Error getting Contacts: \(error)")
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                response.statusCode == 200 else{
                    completion(.failure(.noConnection))
                    return
            }
            
            guard let data = data else{
                completion(.failure(.noData))
                print("Error getting data")
                return
            }
            
            do{
                let jsonDecoder = JSONDecoder()
                self.myContacts = try jsonDecoder.decode(ContactResults.self, from: data)
                completion(.success(self.myContacts!))
            } catch {
                print("Error decoding JSON: \(error)")
                completion(.failure(.decodeFailed))
            }
        }
        task.resume()
    }
    
    // Getting the images for the associated contacts
    func downloadImage(at urlString: String, completion: @escaping (Result<Data, NetworkError>) -> Void){
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, _ , error) in
            if let error = error{
                completion(.failure(.tryAgain))
                print("Error getting image: \(error)")
                return
            }
            
            guard let data = data else{
                completion(.failure(.noData))
                print("Error getting image data")
                return
            }
            completion(.success(data))
        }
        task.resume()
    }}
