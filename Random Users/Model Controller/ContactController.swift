//
//  ContactController.swift
//  Random Users
//
//  Created by Keri Levesque on 3/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

class ContactController {
    
    let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=5000")!
    
    typealias CompletionHandler = (Error?) -> Void
    
    var contacts: [Contact] = []
    
    var largeImageData: Data?
    
    func fetchContacts(completion: @escaping CompletionHandler = { _ in }) {
        var request = URLRequest(url: baseURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                NSLog("Error retrieving contacts from server. \(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            
            guard let data = data else {
                NSLog("Bad or No data")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            do {
                let fetchedContacts = try JSONDecoder().decode(Results.self, from: data)
                for result in fetchedContacts.results {
                    self.contacts.append(result)
                }
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                NSLog("Error decoding contacts from server: \(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
        }.resume()
    }
    
    func fetchLargeImage(contact: Contact, completion: @escaping CompletionHandler = { _ in }) {
        let largeURL = contact.largeImage
        let request = URLRequest(url: largeURL)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                NSLog("Error fetching Large Image from server: \(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            guard let data = data else {
                NSLog("No or Bad data for Large Image")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            self.largeImageData = data
        }.resume()
    }
}
