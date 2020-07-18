//
//  ContactDetailViewController.swift
//  Random Users
//
//  Created by Bronson Mullens on 7/17/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var contactEmailLabel: UILabel!
    @IBOutlet weak var contactPhoneLabel: UILabel!
    @IBOutlet weak var contactImageView: UIImageView!

    // MARK: - Properties
    
    var contact: Contact?
    var apiController: APIController?
    let cache = Cache<String, Data>()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews() {
        guard let selectedContact = contact else { return }
        
        let fullName:String = ("\(selectedContact.name.title) \(selectedContact.name.first) \(selectedContact.name.last)")
        
        contactNameLabel.text = fullName
        contactEmailLabel.text = selectedContact.email
        contactPhoneLabel.text = selectedContact.phone
        
        if let cachedImage = cache.getValue(key: selectedContact.email),
            let image = UIImage(data: cachedImage) {
            contactImageView.image = image
        }
        fetchImage()
    }
    
    private func fetchImage() {
        guard let selectedContact = contact else { return }
        apiController?.fetchImage(selectedContact.picture.large, completion: { (result) in
            do {
                let imageString = try result.get()
                let image = UIImage(data: imageString)
                self.cache.sendToCache(value: imageString, key: selectedContact.email)
                DispatchQueue.main.async {
                    self.contactImageView.image = image
                }
            } catch {
                NSLog("Error fetching image")
            }
        })
    }
    
}

