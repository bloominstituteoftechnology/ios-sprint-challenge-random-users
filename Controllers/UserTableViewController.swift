//
//  UserTableViewController.swift
//  Random Users
//
//  Created by Ian French on 7/19/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {


    @IBAction func addUserTapped(_ sender: Any) {

        randomUsersController.getUsers { (results) in
           do {
               let users = try results.get()
               DispatchQueue.main.async {
                   self.users = users.results
               }
           } catch {
               print(results)

           }
        }


        
    }

    var randomUsersController = RandomUsersController()
    var users: [UserResults] = [] {
        didSet {
            tableView.reloadData()
            
        }
    }

    private let cache = Cache<String, Data>()
    private let photoQueue = OperationQueue()
    var operation = [String: Operation]()


    override func viewDidLoad() {
        super.viewDidLoad()
        randomUsersController.getUsers { (results) in
            do {
                let users = try results.get()
                DispatchQueue.main.async {
                    self.users = users.results
                }
            } catch {
                print(results)

            }
         }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserTableViewCell else { return UITableViewCell()}

        updateCell(forCell: cell, forItemAt: indexPath)


        return cell
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let currentOperation = users[indexPath.row]
        guard let newOperation = operation[currentOperation.email] else { return }
        newOperation.cancel()
    }


    func updateCell(forCell cell: UserTableViewCell, forItemAt indexPath: IndexPath) {
        let user = users[indexPath.row]

        cell.userName.text = "\(user.name.title) \(user.name.first) \(user.name.last)"


        if let cacheData = cache.value(for: user.email),
            let image = UIImage(data: cacheData) {
            cell.userImage.image = image
            return
        }

        let photoFetchOperation = FetchUserImageOperation(user: user)
        let store = BlockOperation {
            guard let data = photoFetchOperation.imageData else { return }
            self.cache.cache(value: data, for: user.email)
        }

        let isReused = BlockOperation {
            guard let data = photoFetchOperation.imageData else { return }
            cell.userImage.image = UIImage(data: data)
        }

        store.addDependency(photoFetchOperation)
        isReused.addDependency(photoFetchOperation)


        photoQueue.addOperation(photoFetchOperation)
        photoQueue.addOperation(store)

        OperationQueue.main.addOperation(isReused)
        operation[user.email] = photoFetchOperation

    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "userDetailSegue",
            let userDetailVC = segue.destination as? UserDetailViewController,
            let selectedIndexPath = tableView.indexPathForSelectedRow {
            userDetailVC.randomUser = users[selectedIndexPath.row]
        }
    }
}
