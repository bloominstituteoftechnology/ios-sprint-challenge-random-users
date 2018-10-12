//
//  ContactDetailViewController.swift
//  Random Users
//
//  Created by Dillon McElhinney on 10/12/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {

    // MARK: - Properties
    var contact: Contact?
    var tempImage: UIImage?
    private var fetchImageQueue = OperationQueue()
    
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactImageView.image = tempImage
        updateViews()
    }
    
    // MARK: - Utility Methods
    private func updateViews() {
        guard let contact = contact else {
            title = "Add Contact"
            return
        }
        nameLabel.text = contact.name
        emailLabel.text = contact.email
        phoneNumberLabel.text = contact.phoneNumbers.joined(separator: ", ")
        
        let imageFetchOperation = FetchImageOperation(contact: contact, option: .large)
        let updateUIOperation = BlockOperation {
            if let imageData = imageFetchOperation.imageData {
                self.contactImageView.image = UIImage(data: imageData)
            }
        }
        
        updateUIOperation.addDependency(imageFetchOperation)
        
        fetchImageQueue.addOperation(imageFetchOperation)
        OperationQueue.main.addOperation(updateUIOperation)
    }
}
