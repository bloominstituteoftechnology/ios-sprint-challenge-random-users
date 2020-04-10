//
//  PeopleController.swift
//  Random Users
//
//  Created by Karen Rodriguez on 4/10/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class PeopleController {
    var people: [Person] = []
    let baseURL: URL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=30")!
    func fetchPeople(completion: @escaping (Error?) -> ()) {
        URLSession.shared.dataTask(with: baseURL) { d, r, e in
            if let error = e {
                NSLog("Error fetching people : \(error)")
                completion(error)
                return
            }
            
            if let data = d {
                let decoder = JSONDecoder()
                do {
                    let results = try decoder.decode(Results.self, from: data)
                    self.people = results.results
                } catch {
                    NSLog("Couldn't decode received data.")
                    completion(error)
                    return
                }
                print("Got to end of data unwrapping.")
                completion(nil)
                return
            }
        }.resume()
    }
    
}
