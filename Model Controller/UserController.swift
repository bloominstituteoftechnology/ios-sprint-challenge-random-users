//
//  UserController.swift
//  Random Users
//
//  Created by Austin Potts on 2/14/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation


class UserController {
    
    
    var user: [User] = []
          
          let baseURL = URL(string: "https://randomuser.me/api/?format=json&results=1000")!
          
          typealias CompletionHandler = (Error?) -> Void
          
          func getUsers(completion: @escaping CompletionHandler) {
              
              URLSession.shared.dataTask(with: baseURL) {(data, _, error) in
                  
                  if let error = error {
                      NSLog("Error getting users\(error)")
                      completion(nil)
                      return
                      
                  }
                  
                  guard let data = data else {
                      NSLog("No data")
                      completion(nil)
                      return
                  }
                  
                  do {
                      
                      let newUsers = try JSONDecoder().decode(UserResults.self, from: data)
                      print(newUsers)
                      self.user = newUsers.results
                  } catch {
                      NSLog("Error decoding users: \(error)")
                      completion(error)
                  }
                  completion(nil)
              }.resume()
              
          }
          
          
       
       
       
    
    
    
    
}
