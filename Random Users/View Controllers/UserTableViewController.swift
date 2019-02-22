import UIKit

class UserTableViewController: UITableViewController {
    
    //MARK: - Properties
    let userController = UserController.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userController.getUsers()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source
      override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userController.users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as? UserTableViewCell else {fatalError("cannot dequeue table view cell") }

        let user = userController.users[indexPath.row]
        
        return cell
    }

   
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? UserDetailViewController,
            let indexPath = tableView.indexPathForSelectedRow else { return }
        
        let user = userController.users[indexPath.row]
        destination.user = user
    }
}
