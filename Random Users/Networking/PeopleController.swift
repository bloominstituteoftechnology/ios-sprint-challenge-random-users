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
    let baseURL: URL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=10")!
    func fetchPeople() {
        URLSession.shared.dataTask(with: baseURL) { d, r, e in
            if let error = e {
                NSLog("Error fetching people : \(error)")
                return
            }
            
            if let data = d {
                print("got data.")
                return
            }
        }.resume()
    }
    
}
