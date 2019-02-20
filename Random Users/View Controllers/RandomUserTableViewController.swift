import UIKit

class RandomUserTableViewController: UITableViewController {
    
    let randomUserController = RandomUserController()
    private var cache = Cache<URL, Data>()
    private var imageFetchQ = OperationQueue()
    var imageFetchOperations: [URL: FetchRandomUserImageOperation] = [ : ]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        randomUserController.fetchRandomUsers { _ in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return randomUserController.randomPersonResults.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! RandomUserTableViewCell

        // Configure the cell...
        let userAtIndex = randomUserController.randomPersonResults[indexPath.row]
        let thumbURL = randomUserController.randomPersonResults[indexPath.row].thumbnail
        cell.randomUserCellNameLabel.text = userAtIndex.fullName
        cell.randomUserCellImageView.loadImageFrom(url: URL(string: thumbURL)!)

        return cell
    }
   

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let userImage = randomUserController.randomPersonResults[indexPath.row]
        if let userImageFetchOperation = imageFetchOperations[URL(string: userImage.thumbnail)!] {
            userImageFetchOperation.cancel()
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "RandomUserDetail"{
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let randomUser = randomUserController.randomPersonResults[indexPath.row]
            let randomPersonDetailVC = segue.destination as! RandomUserDetailViewController
            randomPersonDetailVC.randomUser = randomUser
            
        }
        
    }
   
    // Fetch User Images Operation
    
    func fetchUserImages(for cell: RandomUserTableViewCell, at indexPath: IndexPath) {
        let userImage = randomUserController.randomPersonResults[indexPath.row]
        
        if let imageData = cache.value(forKey: URL(string: userImage.thumbnail)!) {
            let image = UIImage(data: imageData)
            cell.randomUserCellImageView.image = image
        }
        
        let userImageOperation = FetchRandomUserImageOperation(reference: userImage)
        let imageCacheOperation = BlockOperation {
            self.cache.cache(value: userImageOperation.imageData!, forKey: URL(string: userImage.thumbnail)!)
        }
        
        let userImageFetchOperation = BlockOperation {
            if let imageData = userImageOperation.imageData {
                let image = UIImage(data: imageData)
                cell.randomUserCellImageView.image = image
            }
        }
        
        imageCacheOperation.addDependency(userImageOperation)
        userImageFetchOperation.addDependency(userImageOperation)
        imageFetchOperations[URL(string: userImage.thumbnail)!] = userImageOperation
        imageFetchQ.addOperations([userImageOperation, imageCacheOperation], waitUntilFinished: true)
        OperationQueue.main.addOperations([userImageFetchOperation], waitUntilFinished: true)
    }

}
