//
//  ContactDetailViewController.swift
//  Random Users
//
//  Created by Michael on 2/14/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {
    
    typealias CompletionHandler = (Error?) -> Void
    
    var cache = Cache<String, Data>()
    
    var contact: Contact? {
        didSet {
            
        }
    }
    
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var contactPhoneLabel: UILabel!
    @IBOutlet weak var contactEmailLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        loadLargeImage()
    }
    
    func updateViews() {
        guard let contact = contact else { return }
        contactNameLabel.text = contact.name
        contactPhoneLabel.text = contact.phone
        contactEmailLabel.text = contact.email
    
    }
    
    func loadLargeImage() {
        guard let contact = contact else { return }
        let key = contact.name
        let largeURL = contact.largeImage
        let request = URLRequest(url: largeURL)
        
        if let cachedData = cache.largeValue(for: key) {
            let image = UIImage(data: cachedData)
            DispatchQueue.main.async {
                self.contactImageView.image = image
            }
        } else {
            URLSession.shared.dataTask(with: request) { data, _, error in
                if let error = error {
                    NSLog("Error fetching Large Image data: \(error)")
                    return
                }
                guard let data = data else {
                    NSLog("No or Bad data for Large Image")
                    return
                }
                self.cache.largeCache(value: data, for: key)
                DispatchQueue.main.async {
                    self.contactImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
}
