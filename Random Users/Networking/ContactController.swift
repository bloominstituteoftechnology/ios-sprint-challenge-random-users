//
//  ContactController.swift
//  Random Users
//
//  Created by Tobi Kuyoro on 10/04/2020.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class ContactController {
    
    // MARK: Properties
    
    let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    var contacts: [Contact] = []
    
    // MARK: Networking
    
    func fetchContacts(completion: @escaping (Error?) -> Void = { _ in }) {
        URLSession.shared.dataTask(with: baseURL) { data, _, error in
            if let error = error {
                NSLog("Error fetching users from API: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No contact data")
                completion(NSError())
                return
            }
            
            do {
                let contact = try JSONDecoder().decode(Contact.self, from: data)
                self.contacts.append(contact)
            } catch {
                NSLog("Error decoding contact JSON: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
}
