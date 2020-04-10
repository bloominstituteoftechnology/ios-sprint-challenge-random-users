//
//  FaceController.swift
//  Random Users
//
//  Created by Bradley Diroff on 4/10/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class FaceController {
    
    let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
    var faces: [Face] = []
    
    func getYourFace(completion: @escaping ((Error?) -> Void) = { _ in}) {
        
        URLSession.shared.dataTask(with: baseURL.appendingPathExtension("json")) { (data, result, error) in
        
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
                print("JSON about to happen")
                print(data)
                let faceTime = Array(try JSONDecoder().decode([String: Face].self, from: data).values)
          //      let faceTime = try JSONDecoder().decode([Face].self, from: data)
                print("JSON HAPPENED")
                self.faces = faceTime
                completion(nil)
            } catch {
                print(error)
                completion(error)
            }
            
            }.resume()
    }
    
}
