//
//  UserProfilesTableViewController.swift
//  Random Users
//
//  Created by Victor  on 6/7/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

class UserProfileTableViewController: UITableViewController {
    // MARK: - Properties
    
    var users: [User] = []
    var userImages: [String : Data] = [:]
    var networkClient = NetworkClient()
    private var cache = Cache<String, User>()
    private var imageOperationQueue = OperationQueue()
    private var imageFetchOperations: [String : ImageFetchOperation] = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserProfileCell", for: indexPath) as! UserProfileTableViewCell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        let fetchOperation = imageFetchOperations[user.id]
        fetchOperation?.cancel()
    }
    

}
