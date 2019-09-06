//
//  UserTableViewController.swift
//  Random Users
//
//  Created by Bradley Yin on 9/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {
    
    var users: [User] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        getUsers()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    func getUsers() {
        let url = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                NSLog("Error getting user: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("no data when getting user")
                return
            }
            do {
                let userDict = try JSONDecoder().decode([String : [User]].self, from: data)
                self.users = userDict["results"]!
                print(self.users)
            } catch {
                NSLog("Error decoding: \(error)")
                return
            }
        }.resume()
    }
}
