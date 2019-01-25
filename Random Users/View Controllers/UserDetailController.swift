//
//  UserDetailController.swift
//  Random Users
//
//  Created by Lotanna Igwe-Odunze on 1/25/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailController: UIViewController {
    
    override func viewDidLoad() {
        showUser()
    }
    
    //Outlets
    @IBOutlet weak var mainPhoto: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    //Properties
    var currentUser: User?
    private var photoQueue = OperationQueue() //My background queue for photos
    

    
    func showUser() {
        
        //Using the photo operation to download the main photo.
        let mainPhotoDownload = PhotoOperation(theUser: currentUser!, size: .large)
        
        let addMainPhotoOp = BlockOperation { //Updating the main photo
            
            if let mainPhotoData = mainPhotoDownload.photoData {
                self.mainPhoto.image = UIImage(data: mainPhotoData)
            } //End of unwrapping photo data
        } //End of updating the main photo
        
        //Updating the main photo is dependent on the success of it downloading.
        addMainPhotoOp.addDependency(mainPhotoDownload)
        
        //Downloading the main photo should happen on the background photo queue.
        photoQueue.addOperation(mainPhotoDownload)
      
        //Update the main photo on the main queue since it's part of the UI.
        OperationQueue.main.addOperation(addMainPhotoOp)
        

        //Updating the labels via regular assignments
        nameLabel.text = "\(currentUser?.name.first) \(currentUser?.name.last)"
        phoneLabel.text = "\(currentUser?.cell)"
        emailLabel.text = "\(currentUser?.email)"
        
        
    }
    
}
