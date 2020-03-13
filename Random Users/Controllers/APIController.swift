//
//  APIController.swift
//  Random Users
//
//  Created by Tobi Kuyoro on 13/03/2020.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class APIController {
    
    // MARK: - Properties
    
    let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
    typealias CompletionHandler = (Error?) -> Void
    
    var contacts: [Contact] = []
    
    // MARK: - Networking
    
    func getContacts(completion: @escaping CompletionHandler = { _ in }) {
        URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
            if let error = error {
                NSLog("Error getting contacts: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data for contacts")
                completion(NSError())
                return
            }
            
            do {
                let contactsJSON = try JSONDecoder().decode(ContactResults.self, from: data)
                self.contacts = contactsJSON.results
                completion(nil)
            } catch {
                NSLog("Error decoding fetched contacts:\(error)")
                completion(error)
                return
            }
        }.resume()
    }
}

