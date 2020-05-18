import UIKit

class ContactsTableViewController: UITableViewController {

    
    // MARK: - Properties
    
    private let controller = RandomUserController()
    
    private var users = [User]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    // MARK: - Table View Data Source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Person Cell", for: indexPath) as? PersonTableViewCell ?? PersonTableViewCell()

        cell.user = users[indexPath.item]

        return cell
    }
    
    
    // MARK: - IBActions
    @IBAction func refreshTapped(_ sender: UIBarButtonItem) {
        controller.fetchRandomUsers { result in
            do {
                let users = try result.get()
                DispatchQueue.main.async {
                    self.users = users
                }
            } catch {
                if let error = error as? NetworkError {
                    print("Error retriving data \(error)")
                }
            }
        }
    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailSegue" {
            if let detailVC = segue.destination as? DetailViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                 detailVC.person = users[indexPath.row]
                }
            }
        }
    }
}
