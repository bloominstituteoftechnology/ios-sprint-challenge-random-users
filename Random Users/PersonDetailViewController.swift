//
//  PersonDetailViewController.swift
//  Random Users
//
//  Created by Alex Shillingford on 2/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class PersonDetailViewController: UIViewController {
    
    //MARK: - Properties
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var personTitleLabel: UILabel!
    @IBOutlet weak var personNameLabel: UILabel!
    @IBOutlet weak var personNumberLabel: UILabel!
    @IBOutlet weak var personEmailLabel: UILabel!
    var cache: Cache = Cache<String, Data>()
    private var operations = [String: Operation]()
    private let photoFetchQueue = OperationQueue()
    
    var person: Person? {
        didSet {
            updateViews()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    private func updateViews() {
        guard isViewLoaded else { return }
        guard let person = person else { return }
        getImage(forPerson: person)
        personTitleLabel.text = person.title
        personNameLabel.text = "\(person.firstName) \(person.lastName)"
        personEmailLabel.text = person.email
        personNumberLabel.text = person.cell
        let fetchPhoto = FetchPhotoOperation(photoType: .LargePicture, person: person)
        if let imageData = fetchPhoto.imageData {
            personImageView.image = UIImage(data: imageData)
        }
       
    }
    
    func getImage(forPerson person: Person) {
        
        
               if let cachedData = cache.value(forKey: person.firstName), let image = UIImage(data: cachedData) {
                personImageView.image = UIImage(data: cachedData)
                   return
               }

                  // TODO: Implement image loading here
               let fetchOperation = FetchPhotoOperation(photoType: .LargePicture, person: person)
               let cacheOp = BlockOperation {
                   if let data = fetchOperation.imageData {
                       self.cache.cache(value: data, forKey: person.id)
                   }
               }
               
        let completionOp = BlockOperation {
                defer {self.operations.removeValue(forKey: person.firstName)}
                    print("got image for reused image")
                if let data = fetchOperation.imageData {
                    self.personImageView.image = UIImage(data: data)
                }
            }
            
                  cacheOp.addDependency(fetchOperation)
                  completionOp.addDependency(fetchOperation)
                  photoFetchQueue.addOperation(fetchOperation)
                  photoFetchQueue.addOperation(cacheOp)
                  OperationQueue.main.addOperation(completionOp)
                  operations[person.id] = fetchOperation
               }
    


}
