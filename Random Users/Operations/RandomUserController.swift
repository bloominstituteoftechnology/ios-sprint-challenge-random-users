//
//  RandomUserController.swift
//  Random Users
//
//  Created by Ivan Caldwell on 2/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class RandomUserController {
    
    typealias CompletionHandler = (Error?) -> Void
    private let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
    func fetchRandomUsers(completionHandler: @escaping CompletionHandler) {
        let requestURL = baseURL
        var results: MessageThread?
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                print("\nRandomUsersController.swift\nError: Fetching random users\n\(error)")
                completionHandler(error)
                return
            }
           
            guard let data = data else {
                print("\nRandomUsersController.swift\nError: No Data")
                completionHandler(nil)
                return
            }
        
            do {
                results = try JSONDecoder().decode(MessageThread.self, from: data)
                Model.shared.randomUsers = results
                completionHandler(nil)
            } catch {
                fatalError("\nRandomUsersController.swift\nError: Could not decode JSON")
            }
        }.resume()
    }
}
