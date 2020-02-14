//
//  FetchUsersTableViewController.swift
//  Random Users
//
//  Created by Kenny on 2/14/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit
import Foundation

class FetchUsersTableViewController: UITableViewController {
    //=======================
    // MARK: - Types
    enum Identifiers: String {
        case userDetail = "UserDetailViewControllerSegue"
    }
    
    //=======================
    // MARK: - Properties
    var users = [User]()
    private let queue = OperationQueue()
    
    //=======================
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUsers()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    //=======================
    // MARK: - TableView DataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        return cell
    }
    
    //=======================
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Identifiers.userDetail.rawValue {
            guard let destination = segue.destination as? UserDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow,
                users.count >= indexPath.row //could crash since I can't make users an optional
            else { return }
            destination.user = users[indexPath.row]
            
        }
    }
    
    //=======================
    // MARK: - Operations
    func fetchUsers() {
        guard let baseUrl = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000") else {return}
        URLSession.shared.dataTask(with: baseUrl) { (data, _, error) in
            if let error = error {
                print(error)
                return
            }
            guard let data = data else {return}
            do {
                let userResults = try JSONDecoder().decode(UserResults.self, from: data)
                self.users = userResults.results
                
                //=======================
                // MARK: - ##Test FetchOp##
                let imageFetchOp = UserImageFetchOperation(user: self.users[0])
                imageFetchOp.fetchPhoto(imageType: .thumbnail)
                
                let setImgOp = BlockOperation {
                    DispatchQueue.main.async {
                        if let imageData = imageFetchOp.imageData {
                            print(imageData)
                        }
                    }
                }
                setImgOp.addDependency(imageFetchOp)
                
                self.queue.addOperations([
                    imageFetchOp
                    //queue
                ], waitUntilFinished: false)
                OperationQueue.main.addOperation(setImgOp)
            } catch {
                print(error)
            }
        }.resume()
    }
}
