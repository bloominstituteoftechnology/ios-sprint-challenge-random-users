
import UIKit

class UsersTableViewController: UITableViewController {
    
    // Properties
    
    let userController = UserController.shared
    
    // <Email, Image>
    var cache = Cache<String, UIImage>()
    
    var operationCache = Cache<IndexPath, Operation>()
    
    // In order to execute operation, create an operation queue
    let downloadImageQueue: OperationQueue = {
       let q = OperationQueue()
        q.name = "Download Image Queue"
        return q
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userController.getUsers { (_) in
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
    }
    
    // Number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userController.users.count
    }
    
    // Cell contents
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.reuseIdentifier, for: indexPath) as! UserTableViewCell
        
        // get the user associated with the cell
        let user = userController.users[indexPath.row]

        // pass the model object to the cell
        cell.user = user
        
        // load the image associated with the cell
        loadImage(forCell: cell, forItemAt: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // The cell has gone offscreen, so cancel the operation
        
        // I will know which operation to cancel by keeping a list of all the operations I've started so that I can look them up
        
        // When I'm done displaying my cell, see if I got my operation
        if let existingOperation = operationCache.getValue(for: indexPath) {
            existingOperation.cancel()
            // Don't need to remove operation from cache here b/c it will be removed when the operation "completes" with a cancellation error
        }
    }
    
    private func loadImage(forCell cell: UserTableViewCell, forItemAt indexPath: IndexPath) {
        
        let userReference = UserController.shared.users[indexPath.item]
        
        let userReferenceImageURL = URL(string: userReference.picture)!
        
        // Check if cache already contains data for given user reference's email
        if let value = cache.getValue(for: userReference.email) {

            // if it does, set cell's image
            let image = value
            cell.userImage.image = image
        }
        
        // Create image operation
        let imageOperation = DownloadImageOperation(url: userReferenceImageURL) { image in
            
            // Whether I download an image or not, I want to remove that operation from the cache
            // Cache is already thread-safe, so this is safe to do from the background
            self.operationCache.removeValue(for: indexPath)
            
            // guard that I have an image
            guard let image = image else { return }
            
            // Save retrieved image data to cache
            self.cache.saveValue(image, for: userReference.email)
            
            // Put image into the UI
            DispatchQueue.main.async {
                
                // if the cell for this index path is visible right now...
                if let visibleCell = self.tableView.cellForRow(at: indexPath) as? UserTableViewCell {
                    
                    // set the cell's image
                    visibleCell.userImage.image = image
                }
            }
        }
        
        // When I create my operation, I will cash it
        operationCache.saveValue(imageOperation, for: indexPath)
        
        downloadImageQueue.addOperation(imageOperation)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let destination = segue.destination as? UserDetailViewController,
            let indexPath = tableView.indexPathForSelectedRow else { return }
        
        // Pass the user that corresponds with tapped cell
        let user = userController.users[indexPath.row]
        
        // Pass the selected object to the detail view controller
        destination.user = user
    }
}
