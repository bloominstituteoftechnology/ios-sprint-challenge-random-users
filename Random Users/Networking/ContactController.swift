//
//  ContactController.swift
//  Random Users
//
//  Created by BrysonSaclausa on 9/12/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

//APIController


class ContactController {

    var myContacts: ContactResults?
    let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!

    
    enum NetworkError: Error {
        case noData
        case noImageData
        case noDecode
        case downloadError
    }
    
    
    func fetchContacts(completion: @escaping (Result<ContactResults, NetworkError>) -> Void ) {
        var request = URLRequest(url: baseURL)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let err = error {
                print("error:\(err)")
                completion(.failure(.downloadError))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                response.statusCode == 200 else {
                    completion(.failure(.downloadError))
                    return
            }
            
            guard let data = data else {
                completion(.failure(.downloadError))
                print("error fetching data")
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                self.myContacts = try jsonDecoder.decode(ContactResults.self, from: data)
                completion(.success(self.myContacts!))
            } catch {
                print("error decoding json: \(error)")
                completion(.failure(.noDecode))
                
            }
            
            
            
        }
        task.resume()
        
    }
        
    
    
    func fetchImage(with urlString: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                completion(.failure(.downloadError))
                print("error fetching image: \(error)")
                return
            }
            
            guard let data = data else {
                completion(.failure(.noImageData))
                print("error getting data")
                return
            }
            
            completion(.success(data))
            
            
        }
        task.resume()
    }
    
    
    
}
