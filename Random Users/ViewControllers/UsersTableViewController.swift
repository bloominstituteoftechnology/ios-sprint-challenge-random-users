//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Niranjan Kumar on 12/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
    
    // MARK: - Properties
    let userContoller = UserController()
    let cache = Cache<URL, Data>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userContoller.fetchUsers { (error) in
            if let error = error {
                print("Error loading users: \(error)")
                print("\(#file):L\(#line): Code failed inside \(#function)")
                return
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userContoller.users.count
    }
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserTableViewCell else { return UITableViewCell() }
        
        
        return cell
     }
    
    // MARK: - Private
    private func loadImage(forCell cell: UserTableViewCell, forItemAt indexPath: IndexPath) {
        let photoReference = 
    }


     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
