
import UIKit

class UsersTableViewController: UITableViewController {
    
    // Array of users
    var users: [User] = [] {
        
        // Anytime this variable changes...
        didSet {
            
            // Reload UIKit on the main queue
            DispatchQueue.main.async {
                // ...reload the table view
                self.tableView.reloadData()
            }
        }
        
    }
    
    
}
