//
//  PersonController.swift
//  Random Users
//
//  Created by Joshua Sharp on 10/4/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

//MARK: - Class

class PersonController {
    //MARK: - Properties
    private let numPeople = 1000
    var people: [Person] = []
    var idPeople: [UUID: Person] = [:]
    
    //MARK: - Methods
    
    init () {
        //fetchPeople()
    }
    
    func create (person: Person) {
        
    }
    
    //Mark: - Network API
    let baseURL: URL = URL(string:"https://randomuser.me/api/")!
    
    func fetchPeople (completion: @escaping (_ error: Error?) -> Void) {
        var url = baseURL
        let urlComponents = NSURLComponents(url: url, resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = [URLQueryItem(name: "format", value: "json"),
                                    URLQueryItem(name: "inc", value: "name,email,phone,picture"),
                                    URLQueryItem(name: "results", value: String(numPeople))]
        url = urlComponents.url!
        fetch(from: url) { (results: Results?, error: Error?) in
            if let error = error {
                NSLog("Error fetching people: \(error)")
                completion(error)
                return
            }
            if let results = results {
                //let resultsString = String(describing: results.results)
                //print ("Results fetched: \(resultsString)")
                self.people = results.results
                completion(nil)
            }
        }
        
    }
    
    private func fetch<T: Codable>(from url: URL,
                                   using session: URLSession = URLSession.shared,
                                   completion: @escaping (T?, Error?) -> Void) {
        session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "info.emptybliss.randomusers.ErrorDomain", code: -1, userInfo: nil))
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                let decoded = try jsonDecoder.decode(T.self, from: data)
                completion(decoded, nil)
            } catch {
                completion(nil, error)
            }
            }.resume()
    }
}
