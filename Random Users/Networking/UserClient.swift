//
//  UserClient.swift
//  Random Users
//
//  Created by De MicheliStefano on 07.09.18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation

class UserClient {
    
    private let baseURL: URL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
    func fetchUsers(completion: @escaping ([User]?, Error?) -> Void) {
        let request = URLRequest(url: baseURL)
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching data from network: \(error)")
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                NSLog("Error loading data from network")
                completion(nil, NSError())
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(Users.self, from: data).results
                completion(decodedData, nil)
            } catch {
                NSLog("Error decoding data: \(error)")
                completion(nil, error)
                return
            }
        }.resume()
    }
    
}
