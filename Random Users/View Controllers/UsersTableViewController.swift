
import UIKit

class UsersTableViewController: UITableViewController {
    
    // Properties
    
    let userController = UserController.shared
    
    var cache = Cache<String, String>()
    
    // Array of users
//    var users: [User] = [] {
//
//        // Anytime this variable changes...
//        didSet {
//
//            // Reload UIKit on the main queue
//            DispatchQueue.main.async {
//                // ...reload the table view
//                self.tableView.reloadData()
//            }
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userController.getUsers { (_) in
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            
        }
        //print("---------------------")
        //print(users)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
    }
    
    // Number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 3
        //return users.count
        return userController.users.count
        //return userController.userResults.count
    }
    
    // Cell contents
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.reuseIdentifier, for: indexPath) as! UserTableViewCell
        
        // get the user associated with the cell
        let user = userController.users[indexPath.row]
        
        // pass the model object to the cell
        cell.user = user
        
        return cell
    }
    
    private func loadImage(forCell cell: UserTableViewCell, forItemAt indexPath: IndexPath) {
        
        
        
        
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
