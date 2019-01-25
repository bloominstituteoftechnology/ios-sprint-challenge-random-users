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
            let results = try jsonDecoder.decode(RandomUsers.self, from: data)
            Model.shared.randomUsers = results
            print(Model.shared.randomUsers)
            completionHandler(nil)
        } catch {
            fatalError("Could not decode JSON")
            completionHandler(NSError())
        }
    }.resume()
}
    func fetchSingleRandomUser(completionHandler: @escaping CompletionHandler) -> RandomUser? {
        let requestURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1")
        var randomUser: RandomUser?
        
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
            print(data)
            let jsonDecoder = JSONDecoder()
            do {
                let results = try jsonDecoder.decode(RandomUsers.self, from: data)
                randomUser = results.results[0]
                completionHandler(nil)
            } catch {
                completionHandler(error)
            }
            }.resume()
        return randomUser
        
    }
    
    //MARK: Properties
    
    var randomUsers: RandomUsers? {
        didSet {
            Model.shared.randomUsers = randomUsers
        }
    }
    typealias CompletionHandler = (Error?) -> (Void)
    let baseUrl = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")
    
}
