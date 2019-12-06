//
//  PersonClientAPI.swift
//  Random Users
//
//  Created by brian vilchez on 12/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class PersonClientAPI {
    var persons = [Person]()
    var cache = Cache<String, Data>()
    let baseURL = URL(string: "https://randomuser.me/api/?results=100")
    let urlSession = URLSession.shared
    
    init () {
    }
    
    func fetchRequest(completion: @escaping(Error?) -> Void = { _ in }) {
        guard let requestURL = baseURL else { return }
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        
        urlSession.dataTask(with: request) { (data, response, error) in
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else { return }
            
            if let error = error {
                NSLog("error locating data: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {return }
            
            do {
                let decoder = JSONDecoder()
                let persons = try decoder.decode(Results.self, from: data)
                self.persons.append(contentsOf: persons.results)
                print(persons)
                for person in persons.results {
                    let thumbNailData = try Data(contentsOf: person.thumbNail)
                    let pictureData = try Data(contentsOf: person.largePicture)
                    self.cache.cache(value: thumbNailData, forKey: person.id)
                    self.cache.cache(value: pictureData, forKey: person.firstName)
                    
                completion(nil)
                }
                
            } catch {
                NSLog("error decoding data: \(error.localizedDescription)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
}
