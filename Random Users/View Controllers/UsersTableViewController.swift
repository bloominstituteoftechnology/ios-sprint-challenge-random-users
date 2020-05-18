//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Waseem Idelbi on 5/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
    //MARK: - Properties and IBOutlets -
    
    var userController = UserController()
    
    //MARK: - Methods and IBActions -
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1000
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserTableViewCell
        
        let baseURL = userController.urlForFetching(numberOfUsers: 1000)
        
        //---------------------------------
        
        var request = URLRequest(url: baseURL)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                
                NSLog("URLSession failed: \(error)")
                return
            }
            
            guard let data = data else {
                
                NSLog("Could not get data: \(String(describing: error))")
                return
            }
            
            do {
                let randomUser = try JSONDecoder().decode(User.self, from: data)
                self.userController.users.insert(randomUser, at: indexPath.row)
                
            } catch {
                
                NSLog("Could not decode generated user data: \(error)")
                return
            }
        }
        task.resume()
        
        //---------------------------------
        
//        let dataTask = URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
//            
//            if let error = error {
//                
//                NSLog("URLSession failed: \(error)")
//                return
//            }
//            
//            guard let data = data else {
//                
//                NSLog("Could not get data: \(String(describing: error))")
//                return
//            }
//            
//            do {
//                let randomUser = try JSONDecoder().decode(User.self, from: data)
//                self.userController.users.insert(randomUser, at: indexPath.row)
//                
//            } catch {
//                
//                NSLog("Could not decode generated user data: \(error)")
//                return
//            }
//        }
//        dataTask.resume()
        
        //---------------------------------
        
        //        userController.getUser(row: indexPath.row) { (result) in
        //
        //            do {
        //                cell.randomUser = try result.get()
        //            } catch {
        //                NSLog("Could not assign random user: \(error)")
        //                return
        //            }
        //
        //        }
        //
        //        let randomUser = userController.users[indexPath.row]
        //        cell.randomUser = randomUser
        //        userController.getUserImage(imageURLString: randomUser.picture.thumbnail) { (result) in
        //
        //            do {
        //                cell.imageView?.image = try result.get()
        //            } catch {
        //                NSLog("Could not assign image: \(error)")
        //                return
        //            }
        //
        //        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        
    }
    
    
} //End of class
