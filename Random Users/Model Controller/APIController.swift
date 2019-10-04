//
//  APIController.swift
//  Random Users
//
//  Created by Marc Jacques on 10/4/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class APIController {
    static let shared = APIController()
    var users: [User] = []
    
    let baseURL = URL(string: "https://randomuser.me/api/?format=json&results=50")!
    typealias CompletionHandler = (Error?) -> Void // if we run into an error hop out of the closure
    
    func getUsers(completion: @escaping CompletionHandler = { _ in }) {
        URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
            if let error = error { // were using if let because we don't really care whether or not theres an error
                NSLog("Error getting users: \(error)") //NSLOG documents more info such as time and other details
            }
            guard let data = data else { // we absolutely need data so we use guard
                NSLog("No data returned from data task.")
                completion(nil) //if we don't get data get out
                return
            }
            do {
                let newUser = try JSONDecoder().decode(UserResult.self, from: data) // userResults.self is collecting all of the data from the API
                print(newUser)
                self.users = newUser.result //make the empty array = to the new array that you just collected from the api
            } catch {
                NSLog("Error decoding users: \(error)")
                completion(error)
            }
            completion(nil)
        }.resume()
        
    }
}
