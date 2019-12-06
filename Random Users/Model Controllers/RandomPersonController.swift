//
//  RandomPersonController.swift
//  Random Users
//
//  Created by Dennis Rudolph on 12/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class RandomPersonController {

    let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
    struct Results: Decodable {
        var results: [RandomPerson]
    }
    
    func fetchRandomPeople (completion: @escaping ([RandomPerson]?) -> Void) {
        var requestURL = URLRequest(url: baseURL)
        requestURL.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: requestURL, completionHandler: { (data, _, error) in
            if let error = error {
                print("Error fetching people: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("Error loading data")
                completion(nil)
                return
            }
            
            do {
                let fetchedPeople = try JSONDecoder().decode(Results.self, from: data)
                completion(fetchedPeople.results)
            } catch {
                print("Error decoding data: \(error)")
                completion(nil)
                return
            }
        }).resume()
    }
}

