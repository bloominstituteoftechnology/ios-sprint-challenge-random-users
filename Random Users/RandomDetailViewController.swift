//
//  RandomDetailViewController.swift
//  Random Users
//
//  Created by Yvette Zhukovsky on 11/30/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class RandomDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let randomUser = randomUser else { return }
        let imageOperation = FetchingImages(randomUsers: randomUser)
        let operation = BlockOperation {
            guard let image = imageOperation.Image else { return }
            self.imageViewUser.image = image
        
        
    }
    
        operation.addDependency(imageOperation)
        
       userFetchQueue.addOperation(imageOperation)
        OperationQueue.main.addOperation(operation)
       phone.text = randomUser.phone
       name.text = randomUser.name
       
        email.text = randomUser.email
        
        
        
        
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
     let userFetchQueue = OperationQueue()
    var randomUser: RandomUser?
    
    @IBOutlet weak var imageViewUser: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var phone: UILabel!
    
    @IBOutlet weak var email: UILabel!
    
}
