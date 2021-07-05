//
//  RandomUserController.swift
//  Random Users
//
//  Created by Austin Cole on 1/25/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class RandomUserController {

func fetchRandomUsers(completionHandler: @escaping CompletionHandler) {
    let requestURL = baseUrl
    var results: RandomUsers?
    
    URLSession.shared.dataTask(with: requestURL!) { (data, _, error) in
        if let error = error {
            print("error fetching random users")
            completionHandler(error)
            return
        }
        guard let data = data else {
            print("error getting data")
            completionHandler(nil)
            return
        }
        let jsonDecoder = JSONDecoder()
        do {
            results = try jsonDecoder.decode(RandomUsers.self, from: data)
            Model.shared.randomUsers = results
            completionHandler(nil)
        } catch {
            fatalError("Could not decode JSON")
        }
    }.resume()
}
    
    //MARK: Properties
    typealias CompletionHandler = (Error?) -> (Void)
    let baseUrl = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")
    
}
