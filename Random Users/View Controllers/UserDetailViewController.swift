//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Vici Shaweddy on 11/9/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var emailText: UILabel!
    @IBOutlet weak var phoneText: UILabel!
    
    private let pictureFetchQueue = OperationQueue()
    var randomUserController: RandomUserController?
    var randomUser: RandomUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.updateViews()
    }
    
    // MARK: - Private
    
    func updateViews() {
        if let user = self.randomUser {
            self.nameText.text = user.fullName
            self.emailText.text = user.email
            self.phoneText.text = user.phone
            
            let fetchOp = FetchPictureOperation(url: user.picture.large)
            
            let setOp = BlockOperation {
                DispatchQueue.main.async {
                    self.imageView.image = fetchOp.image
                }
            }
            
            setOp.addDependency(fetchOp)
            pictureFetchQueue.addOperations([fetchOp, setOp], waitUntilFinished: false)
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
