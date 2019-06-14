//
//  PersonDetailViewController.swift
//  Random Users
//
//  Created by Kobe McKee on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class PersonDetailViewController: UIViewController {

    var cache = Cache<String, Data>()
    var largeImageFetchQueue = OperationQueue()
    var largeImageFetchOperations: [String : FetchLargeImageOperation] = [:]
    var personController: PersonController?
    var person: Person? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var largeImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    
    func updateViews() {
        guard isViewLoaded,
            let person = person else { return }
        
        nameLabel.text = person.name
        emailLabel.text = ("Email: \(person.email)")
        phoneLabel.text = ("Phone Number: \(person.phone)")
        
        loadLargeImage(person: person)
        
    }
    
    func loadLargeImage(person: Person) {
        
        if let cachedImage = cache.value(key: person.email) {
            self.largeImageView.image = UIImage(data: cachedImage)
            return
        }
        
        let fetchOp = FetchLargeImageOperation(person: person)
        let cacheOp = BlockOperation {
            if let data = fetchOp.imageData {
                self.cache.cache(value: data, key: person.email)
            }
        }
        
        let checkReuseOp = BlockOperation {
            if self.cache.value(key: person.email) != nil,
                let data = self.cache.value(key: person.email) {
                self.largeImageView.image = UIImage(data: data)
            } else if let imageData = fetchOp.imageData {
                self.largeImageView.image = UIImage(data: imageData)
            }
        }
        
        cacheOp.addDependency(fetchOp)
        checkReuseOp.addDependency(fetchOp)
        
        largeImageFetchQueue.addOperation(fetchOp)
        largeImageFetchQueue.addOperation(cacheOp)
        OperationQueue.main.addOperation(checkReuseOp)
        
        largeImageFetchOperations[person.email] = fetchOp

    }


}
