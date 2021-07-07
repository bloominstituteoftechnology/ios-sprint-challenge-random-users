//
//  PersonController.swift
//  Random Users
//
//  Created by Simon Elhoej Steinmejer on 07/09/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation

class PersonController
{
    private(set) var persons = [Person]()
    
    func fetchPersons(completion: @escaping (Error?) -> ())
    {
        guard let url = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error
            {
                NSLog("Error fetching: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("Error unwrapping data")
                completion(NSError())
                return
            }
            
            do {
                let persons = try JSONDecoder().decode(Results.self, from: data)
                self.persons = persons.results
                completion(nil)
            } catch {
                NSLog("Error decoding: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
}














