//
//  ContactController.swift
//  Random Users
//
//  Created by Morgan Smith on 7/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class ContactController {
    private let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")
    private (set) var contacts: [Contact] = []
    var largeImageCache = Cache<Int, Data>()

    func fetchContacts(completion: @escaping (Error?) -> ()) {
        guard let url = baseURL else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                print("fetchContacts Response: \(response.statusCode)")
            }

            if let error = error {
                print("fetchContacts Error: \(error)")
                completion(error)
                return
            }

            guard let data = data else { return }

            do {
                let decoded = try JSONDecoder().decode(Results.self, from: data)
                self.contacts = decoded.results
                completion(nil)
            }catch {
                print("Error decoding json: \(error)")
                completion(error)
            }
        }.resume()
    }
    
}

