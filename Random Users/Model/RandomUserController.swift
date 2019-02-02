//
//  RandomUserController.swift
//  Random Users
//
//  Created by Ivan Caldwell on 2/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class RandomUserController {

    static let shared = RandomUserController()
    private init() {}
    // Empty array to hold results from fetch
    var randomUsers: [RandomUser] = []
    typealias CompletionHandler = (Error?) -> Void
    private let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
    
    func fetchRandomUsers(completionHandler: @escaping CompletionHandler) {
        let requestURL = baseURL
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                print("\nRandomUserController.swift\nError: Fetching random users\n\(error)")
                completionHandler(error)
                return
            }
           
            guard let data = data else {
                print("\nRandomUserController.swift\nError: No Data")
                completionHandler(nil)
                return
            }
        
            do {
                let fetchResults = try JSONDecoder().decode(RandomUsers.self, from: data)
                self.randomUsers = fetchResults.results
                completionHandler(nil)
            } catch {
                fatalError("\nRandomUsersController.swift\nError: Could not decode JSON")
            }
        }.resume()
    }
}
