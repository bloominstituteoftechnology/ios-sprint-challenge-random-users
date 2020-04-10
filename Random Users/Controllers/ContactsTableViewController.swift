//
//  ContactsTableViewController.swift
//  Random Users
//
//  Created by Mark Gerrior on 4/10/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class ContactsTableViewController: UITableViewController {

    // MARK: - Properties
    private let client = RandomUserClient()
    private let controller = RandomUserController()

    private var users = [User]() {
        didSet {
            DispatchQueue.main.async { self.tableView?.reloadData() }
        }
    }

    // MARK: - Outlets
    
    // MARK: - Actions
    @IBAction func loadButton(_ sender: UIBarButtonItem) {
        controller.fetchRandomUsers() { result in
            do {
                let users = try result.get()
                DispatchQueue.main.async {
                    self.users = users
                }
            } catch {
                if let error = error as? NetworkError {
                    switch error {
                    case .noAuth:
                        NSLog("No auth")
                    case .badAuth:
                        NSLog("Token invalid")
                    case .otherNetworkError:
                        NSLog("Other error occurred, see log")
                    case .badData:
                        NSLog("No data received, or data corrupted")
                    case .noDecode:
                        NSLog("JSON could not be decoded")
                    case .badUrl:
                        NSLog("URL invalid")
                    }
                }
            }
        }
    }
    
    // MARK: - Functions

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath) as? PersonTableViewCell ?? PersonTableViewCell()
        
        cell.user = users[indexPath.item]
//        loadImage(forCell: cell, forItemAt: indexPath) // FIXME:
        
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ViewSegue" {
            if let personVC = segue.destination as? PersonViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    personVC.person = users[indexPath.row]
                }
            }
        }
    }
}
