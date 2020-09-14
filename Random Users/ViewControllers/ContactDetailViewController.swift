//
//  ContactDetailViewController.swift
//  Random Users
//
//  Created by Zachary Thacker on 9/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var contactEmailLabel: UILabel!
    @IBOutlet weak var contactPhoneNumberLabel: UILabel!
    
    // MARK: - Properties
    var contact: Contact?
    var apiController: APIController?
    let cache = Cache<String, Data>()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Private Functions
    private func updateViews(){
        guard let contact = contact else { return }
        contactNameLabel.text = "\(contact.name.title) \(contact.name.first) \(contact.name.last)"
        contactEmailLabel.text = "\(contact.email)"
        contactPhoneNumberLabel.text = "\(contact.phone)"
        if let cachedImage = cache.getValue(for: contact.email),
            let image = UIImage(data: cachedImage){
            contactImageView.image = image
        }
        getImage()
    }
    private func getImage(){
        guard let contact = contact else { return }
        apiController?.downloadImage(at: contact.picture.large , completion: { (result) in
            do{
                let imageString = try result.get()
                let image = UIImage(data: imageString)
                self.cache.storeInCache(value: imageString, for: contact.email)
                DispatchQueue.main.async {
                    self.contactImageView.image = image
                }
            } catch{
                print("Error getting contact's image")
            }
        })
    }
}
