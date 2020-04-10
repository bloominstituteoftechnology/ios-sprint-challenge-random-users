//
//  FaceController.swift
//  Random Users
//
//  Created by Bradley Diroff on 4/10/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class FaceController {
    
    private let baseUrl = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
    var results: Results?
    
    func getYourFace(completion: @escaping ((Error?) -> Void) = { _ in}) {
        
        var request = URLRequest(url: baseUrl)
         request.httpMethod = "GET"
         
         URLSession.shared.dataTask(with: request) { data, response, error in
        
            if let error = error {
                print(error)
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from data task")
                completion(NSError())
                return
            }
            
            do {
                let faceTime = try JSONDecoder().decode(Results.self, from: data)
                self.results = faceTime
                completion(nil)
            } catch {
                print(error)
                NSLog("Error decoding: \(error)")
                completion(error)
            }
            
            }.resume()
    }
    
}
