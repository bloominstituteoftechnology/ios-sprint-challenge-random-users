//
//  PersonController.swift
//  Random Users
//
//  Created by Kobe McKee on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class PersonController {
    
    var people: [Person] = []
    
    typealias CompletionHandler = (Error?) -> Void
    
    private let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!.usingHTTPS!
    
    func fetchPeople(completion: @escaping CompletionHandler = { _ in }) {
        
        URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching people: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned")
                completion(NSError())
                return
            }
            
            do {
                let myPeople = try JSONDecoder().decode(PeopleResults.self, from: data)
                self.people = myPeople.results
                completion(nil)
            } catch {
                NSLog("Error decoding people: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
  
}
