//
//  ContactController.swift
//  Random Users
//
//  Created by Dillon McElhinney on 10/12/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation

class ContactController {
    
    // MARK: - Properties
    private(set) var contacts: [Contact] = []
    private let baseURL = URL(string: "https://randomuser.me/api/")!
    
    // MARK: - Networking
    func fetchContacts(completion: @escaping CompletionHandler = { _ in }) {
        guard var requestComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else {
            completion(NSError())
            return
        }
        let formatQuery = URLQueryItem(name: "format", value: "json")
        let includeQuery = URLQueryItem(name: "inc", value: "name,email,login,phone,cell,picture")
        let resultsQuery = URLQueryItem(name: "results", value: "1000")
        
        requestComponents.queryItems = [formatQuery, includeQuery, resultsQuery]
        
        guard let url = requestComponents.url else {
            NSLog("Couldn't make url from components: \(requestComponents)")
            completion(NSError())
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                NSLog("Error GETting contacts: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data was returned.")
                completion(NSError())
                return
            }
            
            do {
                let contactResults = try JSONDecoder().decode(ContactResults.self, from: data)
                self.contacts = contactResults.results
                completion(nil)
            } catch {
                NSLog("Error decoding contacts: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
    
}
