//
//  PeopleController.swift
//  Random Users
//
//  Created by Dillon P on 11/9/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation


class PeopleController {
    
    private let url = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
    static var shared = PeopleController()
    
    var results: [People] = []
    
    func fetchPeople(completion: @escaping (Error?) -> Void) {
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("Error with data task: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                print("Error getting data for people: \(String(describing: error))")
                completion(error)
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                let results = try jsonDecoder.decode(People.self, from: data)
                self.results.append(results)
                completion(nil)
            } catch {
                print("Error decoding people from data: \(error)")
            }
            
        }.resume()
    }
    
    
}
