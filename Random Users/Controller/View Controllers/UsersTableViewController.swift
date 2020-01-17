//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Chad Rutherford on 1/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import SwiftUI
import UIKit

class UsersTableViewController: UITableViewController {
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Properties
    let usersController = UsersController()
    let photoQueue = OperationQueue()
    var cache = Cache<String, Data>()
    var fetchOperations = [String : FetchPhotoOperation]()
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UsersTableViewCell.self, forCellReuseIdentifier: Cells.usersCell)
        updateViews()
    }
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Private
    private func updateViews() {
        title = "Users"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        usersController.fetchUsers {
            self.tableView.reloadData()
        }
    }
    
    private func fetchImage(for cell: UsersTableViewCell, at indexPath: IndexPath) {
        let imageURL = usersController.users[indexPath.row].thumbnail
        
        if cache.contains(imageURL), let imageData = cache.value(for: imageURL) {
            cell.personImageView.image = UIImage(data: imageData)
            return
        }
        
        let photoFetchOperation = FetchPhotoOperation(imageURL: imageURL)
        
        let cacheOperation = BlockOperation {
            if let imageData = photoFetchOperation.imageData {
                self.cache.cache(value: imageData, for: imageURL)
            }
        }
        
        let updateUIOperation = BlockOperation {
            defer { self.fetchOperations.removeValue(forKey: self.usersController.users[indexPath.row].name) }
            if self.tableView.indexPath(for: cell) != indexPath {
                return
            } else {
                guard let imageData = photoFetchOperation.imageData else { return }
                cell.personImageView.image = UIImage(data: imageData)
            }
        }
        
        cacheOperation.addDependency(photoFetchOperation)
        updateUIOperation.addDependency(photoFetchOperation)
        
        photoQueue.addOperations([photoFetchOperation, cacheOperation], waitUntilFinished: false)
        OperationQueue.main.addOperation(updateUIOperation)
        fetchOperations[usersController.users[indexPath.row].name] = photoFetchOperation
    }
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - TableView Delegate and DataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersController.users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.usersCell, for: indexPath) as? UsersTableViewCell else { return UITableViewCell() }
        cell.user = usersController.users[indexPath.row]
        fetchImage(for: cell, at: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userDetailVC = UsersDetailViewController(nibName: nil, bundle: nil)
        userDetailVC.user = usersController.users[indexPath.row]
        navigationController?.pushViewController(userDetailVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        fetchOperations[usersController.users[indexPath.row].name]?.cancel()
    }
}

// --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
// MARK: - View Controller Previews
struct UsersTableViewControllerPreview: PreviewProvider {
    static var previews: some View {
        ContainerView()
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        func updateUIViewController(_ uiViewController: UsersTableViewControllerPreview.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<UsersTableViewControllerPreview.ContainerView>) {
            
        }
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<UsersTableViewControllerPreview.ContainerView>) -> UIViewController {
            return UINavigationController(rootViewController: UsersTableViewController())
        }
    }
}
