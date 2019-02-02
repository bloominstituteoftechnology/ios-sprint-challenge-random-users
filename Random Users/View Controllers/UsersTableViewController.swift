
import UIKit

class UsersTableViewController: UITableViewController {
    
    // Properties
    
    let userController = UserController.shared
    
    // <Email, ImageURL>
    var cache = Cache<String, Data>()
    
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
    
    private func loadImage(forCell cell: UserTableViewCell, forItemAt indexPath: IndexPath) {
        
        let userReference = UserController.shared.users[indexPath.item]
        
        let userReferenceImageURL = URL(string: userReference.picture)!
        
        // Check if cache already contains data for given user reference's email
        if let value = cache.getValue(for: userReference.email) {
            
            // if it does, set cell's image
            let imageData = value
            cell.userImage.image = UIImage(data: imageData)
            
        } else {
            
            URLSession.shared.dataTask(with: userReferenceImageURL) { (data, _, error) in
                if let error = error {
                    NSLog("Error loading image: \(error)")
                    return
                }
                
                guard let data = data else { return }
                
                // Save retrieved image data to cache
                self.cache.saveValue(data, for: userReference.email)
                
                // Create UIImage from received data
                let retrievedImage = UIImage(data: data)
                
                DispatchQueue.main.async {
                    
                    // if the cell for this index path is visible right now...
                    if let visibleCell = self.tableView.cellForRow(at: indexPath) as? UserTableViewCell {
                        
                        // set the cell's image
                        visibleCell.userImage.image = retrievedImage
                    }
                }
            }
           .resume()
        }
        
        
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
