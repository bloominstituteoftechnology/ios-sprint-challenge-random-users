//
//  NetworkController.swift
//  Random Users
//
//  Created by Cameron Collins on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

/* Call this URL: https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000
    Get and Store 1000 Users
 */
class NetworkController {
    
    //MARK: - Properties
    var users: Results?
    var url = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")
    
    
    //MARK: - Functions
    
    //Requests 100 Users
    func getUsers() {
        
        guard let url = url else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            //Error Checking
            if let error = error {
                print("Error Getting Users in \(#function): \(error)")
                return
            }
            
            guard let tempData = data else {
                print("Bad data in \(#function)")
                return
            }
            
            //Decode Data
            do {
                self.users = try JSONDecoder().decode(Results.self, from: tempData)
            } catch {
                print("Error Decoding JSON in \(#function)")
            }
            
            print("Finished")
            
        }.resume()
    }
    
}
