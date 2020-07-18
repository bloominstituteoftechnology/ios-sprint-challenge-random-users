//
//  ContactDetailViewController.swift
//  Random Users
//
//  Created by Morgan Smith on 7/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {

    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var contactNumber: UILabel!
    @IBOutlet weak var contactEmail: UILabel!

    var contact: Contact?
    var contactIndex: Int?
    var contactController: ContactController?
    private let photoFetchQueue = OperationQueue()
    var fetchPhotoOperations: FetchPhotoOperation?

    override func viewDidLoad() {
        super.viewDidLoad()
        photoFetchQueue.name = "detailPhotoFetchQueue"
        guard let contact = contact else { return }
        contactName?.text = contact.name
        contactNumber?.text = contact.phone
        contactEmail?.text = contact.email
        fetchImage(with: contact.picture[2])
        navigationItem.title = contact.name
    }

    func fetchImage(with url: String) {
        guard let contactIndex = contactIndex else { return }

        if let imageData = contactController?.largeImageCache.value(for: contactIndex) {
            contactImage.image = UIImage(data: imageData)
        }

        let fetchPhotoOperation = FetchPhotoOperation(contactImageUrl: url)
        let storeToCache = BlockOperation {
            if let imageData = fetchPhotoOperation.imageData {
                self.contactController?.largeImageCache.cache(value: imageData, for: contactIndex)
            }
        }

        let setImageOp = BlockOperation {
            guard let imageData = fetchPhotoOperation.imageData else { return }
            self.contactImage?.image = UIImage(data: imageData)
        }

        storeToCache.addDependency(fetchPhotoOperation)
        setImageOp.addDependency(fetchPhotoOperation)

        photoFetchQueue.addOperations([fetchPhotoOperation, storeToCache], waitUntilFinished: false)
        OperationQueue.main.addOperation(setImageOp)
        fetchPhotoOperations = fetchPhotoOperation
    }


}
