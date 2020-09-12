//
//  ContactManagerTableViewController.swift
//  Random Users
//
//  Created by Gladymir Philippe on 9/11/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class ContactManagerTableViewController: UITableViewController {

    // MARK: - Properties
    var apiController = APIController()
    var contacts: [Contact] = []{
        didSet{
            tableView.reloadData()
        }
    }
    private let cache = Cache<String, Data>()
    private let photoFetchQueue = OperationQueue()
    var operation = [String : Operation]()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        apiController.getContacts { (result) in
            do{
                let contacts = try result.get()
                DispatchQueue.main.async {
                    self.contacts = contacts.results
                }
            }catch{
                print("Error getting contacts")
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Giving the navigation bar some color
        view.backgroundColor = UIColor(red: 206, green: 218, blue: 218)
        navigationController?.navigationBar.backgroundColor = UIColor(red: 206, green: 218, blue: 218)
        navigationController?.navigationBar.barTintColor = UIColor(red: 206, green: 218, blue: 218)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as? ContactTableViewCell else { return UITableViewCell() }
        updateCell(forCell: cell, forItemAt: indexPath)
        return cell
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Canceling Network Calls to grab information if the cell is not on the screen
        let currentFetchOperation = contacts[indexPath.row]
        guard let thisOperation = operation[currentFetchOperation.email] else { return }
        thisOperation.cancel()
    }
    // Creating Alternating Cell Backgrounds to give the app some flavor
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let colorEven = UIColor(red: 151, green: 177, blue: 166)
        let colorOdd = UIColor(red: 105, green: 137, blue: 150)
        if(indexPath.row % 2 == 0){
            cell.backgroundColor = colorEven
        } else {
            cell.backgroundColor = colorOdd
        }
    }


    // MARK: - Private Functions
    private func updateCell(forCell cell: ContactTableViewCell, forItemAt indexpath: IndexPath){
        // Getting the contact
        let contact = contacts[indexpath.row]
        // Setting the contact's name label to the correct name
        cell.contactNameLabel.text = "\(contact.name.title) \(contact.name.first) \(contact.name.last)"
        // If a cached Image exists, use the cached image
        // We are using the contact's email as the key for the cache value since it is unique to the contact
        if let cachedImage = cache.getValue(for: contact.email){
            cell.contactImageView.image = UIImage(data: cachedImage)
            return
        }
        // Creating an instance of our Operation
        let photoFetchRequest = FetchContactPhotoOperation(contact: contact)
        // Saving data to the cache as it's loaded
        let storeDataInCache = BlockOperation {
            guard let data = photoFetchRequest.imageData else { return }
            self.cache.storeInCache(value: data, for: contact.email)
        }
        // If data has been saved, don't resave it
        let beenReused = BlockOperation {
            guard let data = photoFetchRequest.imageData else { return }
            cell.contactImageView.image = UIImage(data: data)
        }
        // Adding dependency's to our operations
        storeDataInCache.addDependency(photoFetchRequest)
        beenReused.addDependency(photoFetchRequest)
        // Adding operations to the queue
        photoFetchQueue.addOperation(photoFetchRequest)
        photoFetchQueue.addOperation(storeDataInCache)
        OperationQueue.main.addOperation(beenReused)
        operation[contact.email] = photoFetchRequest
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ContactDetailSegue"{
            if let detailVC = segue.destination as? ContactDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow{
                detailVC.apiController = apiController
                detailVC.contact = contacts[indexPath.row]
            }
        }
    }
}

// MARK: - Extension
// Extension on UIColor in order to give easier color codes
extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}
