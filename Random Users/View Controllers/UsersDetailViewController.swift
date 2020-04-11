//
//  UsersDetailViewController.swift
//  Random Users
//
//  Created by Lambda_School_Loaner_259 on 4/10/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersDetailViewController: UIViewController {
    
    // MARK: - Properties
    var user: User? {
        didSet {
            updateViews()
        }
    }
//    var imageData: UIImage? {
//        didSet {
//            updateViews()
//        }
//    }
    var cache: Cache<String, [UIImage]>?
    private let photoFetchQueue = OperationQueue()
    let queue = OperationQueue.main
    var storedOperations: [String : Operation] = [:]
    
    // MARK: - IBOutlets
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailAddressLabel: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadImage()
        updateViews()
    }
    
    func updateViews() {
        
        guard let user = user, /*let image = imageData,*/ isViewLoaded else { return }
        
        //userImageView.image = image
        
        
        let name = user.name
        let title = name.title
        let first = name.first
        let last = name.last
        let fullName: String
        if title.isEmpty {
            fullName = "\(first.capitalized) \(last.capitalized)"
        } else {
            fullName = "\(title.capitalized). \(first.capitalized) \(last.capitalized)"
        }
        
        userNameLabel.text = fullName
        
        phoneNumberLabel.text = user.phone
        
        emailAddressLabel.text = user.email
    }
    
    private func loadImage() {
        guard let user = user else { return }
        
        if let images = cache?.value(forKey: user.email), images.count == 2, let image = cache?.value(forKey: user.email)?[1] {
            
            userImageView.image = image
            return
        }
        
        let fetchImage = FetchThumbOperation(user: user, imageURL: user.picture.large)
        
        let storeDataOperation = BlockOperation {
            guard let data = fetchImage.imageData else {
                NSLog("fetchThumb.imageData does not have valid data for large image")
                return
            }
            let largeImage = UIImage(data: data) ?? #imageLiteral(resourceName: "MarsPlaceholder")
            let thumbImage = self.cache?.value(forKey: user.email)![0] ?? #imageLiteral(resourceName: "MarsPlaceholder")
            self.cache?.cache(value: [thumbImage, largeImage], forKey: user.email)
        }
        
        let setImageViewOperation = BlockOperation {
            if let data = fetchImage.imageData,
                let image = UIImage(data: data) {
            
                self.userImageView.image = image
                
                return
            }
        }
        
        storeDataOperation.addDependency(fetchImage)
        setImageViewOperation.addDependency(fetchImage)
        
        photoFetchQueue.addOperations([fetchImage, storeDataOperation], waitUntilFinished: true)
        
        queue.addOperation(setImageViewOperation)
        
        storedOperations[user.email] = fetchImage
        
    }
    
//    func loadImage() {
//        let url = URL(string: (user?.picture.large)!)!
//        var urlRequest = URLRequest(url: url)
//        urlRequest.httpMethod = "GET"
//
//        URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
//            if let error = error {
//                NSLog("Error fetching Large image data: \(error)")
//                return
//            }
//
//            guard let data = data else {
//                NSLog("No valid Data from Large image fetch")
//                return
//            }
//
//            let image = UIImage(data: data)
//            DispatchQueue.main.async {
//                self.userImageView.image = image
//                self.updateViews()
//            }
//        }
//    }

}
