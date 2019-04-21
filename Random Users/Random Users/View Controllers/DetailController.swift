//
//  DetailController.swift
//  Random Users
//
//  Created by Lotanna Igwe-Odunze on 2/1/19.
//  Copyright © 2019 Sugabelly LLC. All rights reserved.
//

import UIKit

class DetailController: UIViewController {
    
    override func viewDidLoad() {
        displayContact()
    }
    
    //Outlets
    @IBOutlet weak var heroImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    
    //Properties
    var currentUser: User?
    
    private var heroImageQueue = OperationQueue() //My background queue
    
    func displayContact() {
        
        //Create an instance of the image operation to download the main photo.
        let downloadHeroImage = ImageOperation(contact: currentUser!)
        
        //Create a Block Operation to update the main photo.
        let loadHeroImage = BlockOperation {
            
            //Unwrap the photo data and build an image from the data
            if let heroImageData = downloadHeroImage.imageData {
                self.heroImage.image = UIImage(data: heroImageData)
            } //End of unwrapping photo data
        } //End of updating the main photo
        
        
        //Dependency to make updating the hero image contingent on successful download.
        loadHeroImage.addDependency(downloadHeroImage)
        
        //Downloading the hero image should happen on the background photo queue.
        heroImageQueue.addOperation(downloadHeroImage)
        
        //Updating the hero image on the main queue since it's part of the UI.
        OperationQueue.main.addOperation(loadHeroImage)
        
        
        //Updating the labels via regular assignments
        nameLabel.text = "\(currentUser!.name.first) \(currentUser!.name.last)"
        phoneLabel.text = "\(currentUser!.cell)"
        emailLabel.text = "\(currentUser!.email)"
        
        
    } //End of Function
    
}
