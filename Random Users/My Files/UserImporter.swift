//
//  UserImporter.swift
//  Random Users
//
//  Created by Lotanna Igwe-Odunze on 11/30/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

class UserImporter {
    
    func importUsers(completion: @escaping (Error?) -> Void) {
        
        guard let randomUserAPI = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=10") else { return }
    
//   let user = try? newJSONDecoder().decode(User.self, from: jsonData)
    
        var request = URLRequest(url: randomUserAPI)
    
        request.httpMethod = "GET"
        
        //Requesting both data and the error information in case I can't get the data.
        URLSession.shared.dataTask(with: request) { (data, _, error) in
        print("Error")
            
        if let error = error { //Assigns the standard error to a property so it can be customised.
            
        NSLog("Error: \(error.localizedDescription)") //Print the error description not just the standard error message
        completion(error) //Show error message in Debugger log.
                return } //End of IF statement
        
        //Assigning the data that's fetched to a property for easy manipulation later.
            guard let foundData = data else {
            
                NSLog("Data was not recieved.") //Print this to the Debugger log if there's an error.
            
                completion(error) //Implement the error message if we fail to get data.
            
                return }
        
            do { //Same Do-Catch statement from normal Persistence but from Data above not local file
                
            let jsonDecoder = JSONDecoder() //jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodedUser = try jsonDecoder.decode(User.self, from: foundData)
                
            UserManager().createUser(infoFromAPI: decodedUser)
          
            completion(nil)//Set completion to nothing since decoding worked.
            } catch { //In case Decoding doesn't work.
            NSLog("Error: \(error.localizedDescription)")
            completion(error) //Show error message in Debugger log.
            return }
            
        } .resume() //Resumes the fetch function if it's been suspended e.g. because of errors.
        
    }//End of import users function
    
}
