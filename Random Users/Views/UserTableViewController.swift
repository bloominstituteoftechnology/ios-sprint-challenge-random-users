//
//  UserTableViewController.swift
//  Random Users
//
//  Created by David Williams on 7/19/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {
    
    private let randomUserController = RandomUserController()
    private var users: [Users] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        randomUserController.getUSers { (result) in
            do {
                let name = try result.get()
                DispatchQueue.main.sync {
                    self.users = name
                }
            } catch {
                if let error = error as? RandomUserController.NetworkError {
                    switch error {
                    case .noData:
                        print("Error: The response had no data.")
                    case .decodeFailed:
                        print("Error: The data could not be decoded.")
                    }
                }
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return randomUserController.users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? CustomTableViewCell

        let user = randomUserController.users[indexPath.row]
        cell?.userName.text = (user.name.first + user.name.last)

        return cell!
    }
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
