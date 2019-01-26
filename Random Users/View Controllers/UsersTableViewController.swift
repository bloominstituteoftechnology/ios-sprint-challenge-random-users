import UIKit

class UsersTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userController.fetchUsers { (error) in
            if let error = error {
                NSLog("Error fetching users \(error)")
                return
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userController.users.count
    }

    let reuseIdentifier = "UserCell"
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserTableViewCell

        let user = userController.users[indexPath.row]
        cell.userNameLabel.text = user.name
        
        guard let imageURL = user.thumbnail else { return UITableViewCell() }
        cell.userImageView?.load(url: imageURL)

        return cell
    }

    // MARK: - Navigation // UserDetail

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let detailVC = segue.destination as? DetailViewController else { return }
            let user = userController.users[indexPath.row]
            
            guard let imageURL = user.large else { return }
            detailVC.userImageView.load(url: imageURL)
            
            detailVC.userNameLabel.text = user.name
            detailVC.userPhoneLabel.text = user.phone
            detailVC.userEmailLabel.text = user.email
        }
    }

    let userController = UserController()
}
