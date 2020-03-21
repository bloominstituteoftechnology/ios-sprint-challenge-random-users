//
//  APIController.swift
//  Random Users
//
//  Created by Sal B Amer LpTop on 21/3/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

class APIController {
    
    let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=10")!
    
    typealias CompletionHandler = (Error?) -> Void
    
    var contacts: [Result] = []
    
    var largeImageInfo: Data?
    
    // Fetch results from API
    
    func fetchResults(completion: @escaping CompletionHandler = { _ in }) {
        var request = URLRequest(url: baseURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        // URL Session
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error fetching data from API: \(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            
            guard let data = data else {
                print("Unable to get data or bad data")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            
            //do try block
            
            do {
                let fetchedContacts = try JSONDecoder().decode(Results.self, from: data)
                for result in fetchedContacts.results {
                    self.contacts.append(result)
                }
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                print("Error decoding results from server call: \(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
        }.resume()
    }
    
        // fetch big images
    func fetchLargeImages(contact: Result, completion: @escaping CompletionHandler = { _ in }) {
        let largeImageURL = contact.largeImage
        let request = URLRequest(url: largeImageURL)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error fetching large image from server: \(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            guard let data = data else {
                print("No Large images or Bad Data: \(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            self.largeImageInfo = data
        }.resume()
    }
    
}
















