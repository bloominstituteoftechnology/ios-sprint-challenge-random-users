//
//  RandomUserClient.swift
//  Random Users
//
//  Created by Angel Buenrostro on 3/3/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

class RandomUserController {
    
    func fetchRandomUsers(_ numberOfUsers: Int, completion: @escaping(Error?) -> Void) {
        let baseUrlString = baseURL.absoluteString
        let urlString = baseUrlString + "?results=\(numberOfUsers)"
        let url = URL(string: urlString)!
        print(url)
        
        URLSession.shared.dataTask(with: url){ (data, _, error) in
            if let error = error {
                NSLog("error: \(error)")
                completion(error)
                return
            }
            guard let data = data else {
                print("error fetching data")
                completion(error)
                return
            }
            do {
                let decoder = JSONDecoder()
                let peopleFromServer = try decoder.decode(RandomUser.self, from: data)
                self.people = peopleFromServer.results
                print("Number of People returned: \(peopleFromServer.results.count)")
                completion(nil)
                
            } catch {
                NSLog("Error decoding people from server: \(error)")
                completion(error)
                return
            }
            
            }.resume()
    }
    
    func fetchThumbnailPhotos(person: Person) {
        let url = person.picture["thumbnail"]!
//
//        URLSession.shared.dataTask(with: url){
//            guard let data = data else {
//                print("error finding image")
//            }
//        }
//
    }
    
    
    private let baseURL = URL(string: "https://randomuser.me/api/")!
    
    var people: [Person] = []
}
