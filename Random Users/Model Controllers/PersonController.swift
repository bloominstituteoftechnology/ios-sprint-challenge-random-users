//
//  PersonController.swift
//  Random Users
//
//  Created by John Kouris on 11/9/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

class PersonController {
    
    static let shared = PersonController()
    
    var people: [Person] = []
    
    let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")
    
    func getPeople(completion: @escaping (Error?) -> Void) {
        guard let baseURL = baseURL else { return }
        
        URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
            if let error = error {
                print("Error fetching people data: \(error.localizedDescription)")
                completion(error)
                return
            }
            
            guard let data = data else {
                print("Error getting data")
                completion(error)
                return
            }
            
            do {
                let people = try JSONDecoder().decode(People.self, from: data)
                self.people = people.people
                completion(nil)
            } catch {
                print("Error decoding people: \(error)")
                completion(error)
                return
            }
        }.resume()
        
    }
    
}
