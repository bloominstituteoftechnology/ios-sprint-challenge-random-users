//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Jon Bash on 2019-12-06.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    weak var user: RandomUser?
    
    var operationQueue = OperationQueue()
    weak var imageFetchOp: ImageFetchOperation?

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailAddressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userNameLabel.text = user?.name
        phoneNumberLabel.text = user?.phoneNumber
        emailAddressLabel.text = user?.emailAddress
        if let imageData = user?.imageInfo.fullImageData {
            userImageView.image = UIImage(data: imageData)
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
