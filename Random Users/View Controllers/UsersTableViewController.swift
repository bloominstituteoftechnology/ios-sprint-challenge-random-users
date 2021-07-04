import UIKit

class UsersTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        userController.fetchUsers {_ in
            DispatchQueue.main.async{ self.tableView.reloadData() }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userController.users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UsersTableViewCell.reuseIdentifier, for: indexPath) as! UsersTableViewCell
        
        let user = userController.users[indexPath.row]
        cell.nameLabel.text = user.name

        loadImages(for: cell, at: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let fetchedImage = userController.users[indexPath.row]
        
        if let imageOperation = imageOperations[fetchedImage.thumbnail!] {
            imageOperation.cancel()
        }
    }
  
    private func loadImages(for cell: UsersTableViewCell, at indexPath: IndexPath) {
        
        let fetchedImage = userController.users[indexPath.row]
        
        if let imageData = cache.value(fetchedImage.thumbnail!) {
            let image = UIImage(data: imageData)
            cell.userImageView.image = image
            return
        }
        
        let imageOperation = ImageOperation(imageUrl: fetchedImage)
        let cacheOperation = BlockOperation {
            self.cache.cache(imageOperation.imageData!, fetchedImage.thumbnail!)
        }
        
        let fetchImageOperation = BlockOperation {
            if let imageData = imageOperation.imageData {
                let image = UIImage(data: imageData)
                cell.userImageView.image = image
            }
        }
        
        cacheOperation.addDependency(imageOperation)
        fetchImageOperation.addDependency(imageOperation)
        
        imageOperations[fetchedImage.thumbnail!] = imageOperation
        
        imageQueue.addOperation(imageOperation)
        imageQueue.addOperation(cacheOperation)
        OperationQueue.main.addOperation(fetchImageOperation)
        imageQueue.waitUntilAllOperationsAreFinished()
    }
    
    // MARK: - Navigation
    let identifier = "UserDetail"
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == identifier {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
                let detailUser = userController.users[indexPath.row]
                let detailVC = segue.destination as! DetailViewController
            detailVC.detailUser = detailUser
        }
    }
    
    let userController = UserController()
    private var cache = Cache<URL, Data>()
    var imageOperations: [URL: ImageOperation] = [:]
    private var imageQueue = OperationQueue()
}
