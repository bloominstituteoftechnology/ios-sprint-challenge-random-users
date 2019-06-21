//
//  DetailUserViewController.swift
//  Random Users
//
//  Created by Michael Flowers on 6/21/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class DetailUserViewController: UIViewController {
    
    var storedFetchPhotoOperations: [String : FetchPhotoOperation ] = [:]
    
    //this will be used to put the operations on the right queue
    var photoFetchQueue = OperationQueue()
    
    //we want to use the same cache so we passed this in from tableViewController // reference should be pointing at same cache instance
    var cache: Cache<String, UIImage>? {
        didSet {
            print("DetailUserViewController: Cache was set")
        }
    }
    
    var user: User? {
        didSet {
            updateViews()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
    }
    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    private func updateViews(){
        guard let passedInUser = user, isViewLoaded else { return }
        print("update func hit")
        
        
        if let image = loadLargePhoto(user: passedInUser){
            myImageView.image = image
            
        } else {
            print("loadLargePhoto: Not returning an Image")
        }
        nameLabel.text = passedInUser.fullName
        phoneLabel.text = passedInUser.phone
        emailLabel.text = passedInUser.email
    }
    
    func loadLargePhoto(user: User) -> UIImage? {
        
        var image: UIImage?
        //check to see if the cache contains data from the network, if it does then set the cell's properties and return
        if let imageInCache = cache?.returnCachedValue(forKey: user.fullName){
            //user is in cache so we can set the cell's properties
            image = imageInCache
        } else {
            let fetchPhotoOperation = FetchPhotoOperation(user: user, imageURL: user.largePhoto)
            
            //cacheOperation
            let cacheOperation = BlockOperation {
                guard let data = fetchPhotoOperation.imageData else {print("Error getting data in loadPerson func's cacheOperation"); return }
                guard let image = UIImage(data: data) else { print("Error making image from data in cacheOperation"); return }
                self.cache?.cacheAdd(value: image, forKey: user.fullName)
            }
            
            let setPhotoOperation = BlockOperation {
                guard let data = fetchPhotoOperation.imageData else {print("Error getting data in loadPerson func's cacheOperation"); return }
                guard let myImage = UIImage(data: data) else { print("Error making image from data in cacheOperation"); return }
                image = myImage
               
            }
            
            //make the cache dependent on fetch
            cacheOperation.addDependency(fetchPhotoOperation)
            setPhotoOperation.addDependency(fetchPhotoOperation)
            
            //add each operation to the appropriate queue
            photoFetchQueue.addOperations([fetchPhotoOperation, cacheOperation,setPhotoOperation], waitUntilFinished: true)
            
            //when you finish creating and starting the operations for a cell, add the fetch operation to your dictionary. This way you can retrieve it later to cancel if need be
            storedFetchPhotoOperations[user.fullName] = fetchPhotoOperation
        }
        return image
    }
}

