//
//  ContactDetailViewController.swift
//  Random Users
//
//  Created by Tobi Kuyoro on 10/04/2020.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var contactNumber: UILabel!
    @IBOutlet weak var conctactEmail: UILabel!
    
    // MARK: Properties
    
    var contact: Contact?
    
    var cache = Cache<String, Data>()
    
    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    // MARK: Actions
    
    func updateViews() {
        guard let contact = contact else { return }
        
        contactName.text = contact.name
        contactNumber.text = contact.phone
        conctactEmail.text = contact.email
        
        if let data = cache.value(for: contact.name) {
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self.contactImage.image = image
            }
        }
        
        let request = URLRequest(url: contact.largePicture)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                NSLog("Error fetching large image from server: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("No large image data")
                return
            }
            
            self.cache.cache(value: data, for: contact.name)
            
            DispatchQueue.main.async {
                self.contactImage.image = UIImage(data: data)
            }
        }.resume()
    }
}
