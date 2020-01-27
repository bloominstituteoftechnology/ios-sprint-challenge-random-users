//
//  UserController.swift
//  Random Users
//
//  Created by Craig Swanson on 1/26/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

class UserController {
    
    // MARK: - Properties
    var results: [Friend] = []
    private let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")
    
    func fetchUsers(completion: @escaping (Error?) -> () = {_ in }) {
        var request = URLRequest(url: baseURL!)
        request.httpMethod = "GET"
        
        let fetchUsersTask = URLSession.shared.dataTask(with: request) { (possibleData, _, possibleError) in
            // TODO: Include defer when code moved to Operation class
            
            if possibleError != nil {
                print("Error in retrieving data from fetchUsers task: \(possibleError!)")
                return
            }
            
            guard let data = possibleData else {
                print("Bad data returned in fetchUsers task: \(possibleError!)")
                return
            }
            let decoder = JSONDecoder()
            do {
                let decodedUsers = try decoder.decode(Result.self, from: data)
                self.results = decodedUsers.results
                completion(nil)
            } catch {
                print("Error decoding users: \(possibleError)")
                completion(error)
                return
            }
        }
        fetchUsersTask.resume()
    }
    
    func fetchImage(at url: URL, completion: @escaping (UIImage?, Error?) -> ()) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let _ = error {
                print("Error fetching image from URL: \(error!)")
                return
            }
            
            guard let data = data else {
                print("Bad data in fetching image from URL: \(error!)")
                return
            }
            
            let image = UIImage(data: data)!
            completion(image, nil)
            return
        }.resume()
    }
}
