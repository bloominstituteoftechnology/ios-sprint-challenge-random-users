//Frulwinn

import UIKit

class UserTableViewController: UITableViewController {
    
    //MARK: - Properties
    let userController = UserController.shared
    
    var cache = Cache<String, UIImage>()
    var operationCache = Cache<IndexPath, Operation>()
    
    let fetchPhotoQueue: OperationQueue = {
        let fQ = OperationQueue()
        return fQ
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        userController.getUsers { (_) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userController.users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.reuseIdentifier, for: indexPath) as! UserTableViewCell

        let user = userController.users[indexPath.row]
        cell.user = user
        loadImage(forCell: cell, forItemAt: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let existingOperation = operationCache.getValue(for: indexPath) {
            existingOperation.cancel()
        }
    }
    
    private func loadImage(forCell cell: UserTableViewCell, forItemAt indexPath: IndexPath) {
        let userReference = UserController.shared.users[indexPath.item]
        let userReferenceImageURL = URL(string: userReference.picture)!
        
        if let value = cache.getValue(for: userReference.phone) {
            let image = value
            cell.userImage.image = image
        }
        
        let imageOperation = FetchPhotoOperation(url: userReferenceImageURL) { image in
            self.operationCache.removeValue(for: indexPath)
            
            guard let image = image else { return }
            self.cache.saveValue(image, for: userReference.phone)
            
            DispatchQueue.main.async {
                if let visibleCell = self.tableView.cellForRow(at: indexPath) as? UserTableViewCell {
                    visibleCell.userImage.image = image
                }
            }
        }
        
        fetchPhotoQueue.addOperation(imageOperation)
        operationCache.saveValue(imageOperation, for: indexPath)
    }

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? UserDetailViewController,
            let indexPath = tableView.indexPathForSelectedRow else { return }
        
        let user = userController.users[indexPath.row]
        destination.user = user
        
    }
}
