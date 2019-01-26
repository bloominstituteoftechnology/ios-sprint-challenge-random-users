//
//  UserImporter.swift
//  Random Users
//
//  Created by Lotanna Igwe-Odunze on 1/25/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class UserImporter {
    
    static let shared = UserImporter()
    
    //API URL
    let randomUserAPI = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,cell,picture&results=1000")!
    
    //Import Function
    func downloadUsers(completion: @escaping () -> Void) {
        
        URLSession.shared.dataTask(with: randomUserAPI) {data,_,error in
            
            //Step 1 - Unwrap the error
            
            if let error = error { NSLog(error.localizedDescription); return }
            
            //Step 2 - Unwrap the data
            
            guard let importedData = data else { NSLog("Error: \(error?.localizedDescription))"); return }
            
            //Step 3 - Decode the data
            
            do {
                let decoder = JSONDecoder()
                let myTry = try decoder.decode(Result.self, from: importedData)
                UserManager.shared.addressbook = myTry.results
                
                
            } catch { //In case decoding doesn't work
                NSLog("Error: \(error.localizedDescription)")
                return
                
            } //End of Do-Catch Statement
            
            completion()
            
            } .resume() //End of Data Task
        
    }//End of Function
    
} //End of Class
