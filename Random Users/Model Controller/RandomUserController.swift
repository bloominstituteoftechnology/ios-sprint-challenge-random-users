//
//  RandomUserController.swift
//  Random Users
//
//  Created by Christopher Aronson on 6/7/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

//class RandomUserController {
//    var users: RandomUser?
//
//    init() {
//        loadUsers()
//
//        print("RandomUerserController init")
//    }
//
//    func loadUsers() {
//        let url = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
//        print("RandomUerserController loadUsers")
//        URLSession.shared.dataTask(with: url) { (data, _, error) in
//            if let error = error {
//                NSLog("Error from server: \(error)")
//                return
//            }
//
//            guard let data = data else {
//                NSLog("Server did not send data")
//                return
//            }
//
//            do {
//                let randomUsers = try JSONDecoder().decode(RandomUser.self, from: data)
//                print(randomUsers.results.count)
//                self.users = randomUsers
//            } catch {
//                NSLog("\(error)")
//            }
//        }.resume()
//    }
//}

class RandomUserController: ConcurrentOperation {
    
    var users: RandomUser?
    
    override func start() {
        if isCancelled {
            state = .isFinished
            return
        }
        
        state = .isExecuting
        main()
    }
    
    override func cancel() {
        state = .isFinished
    }
    
    override func main() {
        let url = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            
            if let error = error {
                NSLog("Error while trying to fetch image: \(error)")
                self.state = .isFinished
                return
            }
            
            guard let data = data else {
                NSLog("No data sent back from server")
                self.state = .isFinished
                return
            }
            
            do {
                let randomUsers = try JSONDecoder().decode(RandomUser.self, from: data)
                print(randomUsers.results.count)
                self.users = randomUsers
            } catch {
                NSLog("\(error)")
            }
            
            self.state = .isFinished
        }.resume()
    }
}
