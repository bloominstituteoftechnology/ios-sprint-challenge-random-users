//
//  PersonController.swift
//  Random Users
//
//  Created by Vuk Radosavljevic on 9/7/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation


private let baseURL: URL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!

class PersonController {
    
    var people: [Person] = []
    
    func searchForPeople(completion: @escaping (Error?) -> Void) {
        
        URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching data: \(error)")
                completion(error)
                return
            }
            
            
            guard let data = data else {
                NSLog("Error fetching data. Not data returned")
                completion(NSError())
                return
            }
            
            
            do {
                let searchResults = try JSONDecoder().decode(People.self, from: data)
                self.people = searchResults.results
                print(self.people)
                completion(nil)
            } catch {
                NSLog("Unable to decode data into people: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
}
