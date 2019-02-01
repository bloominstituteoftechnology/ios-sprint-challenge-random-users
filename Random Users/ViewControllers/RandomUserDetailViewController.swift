//
//  RandomUserDetailViewController.swift
//  Random Users
//
//  Created by Sergey Osipyan on 2/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class RandomUserDetailViewController: UIViewController {

    
    
    var randomUser: RandomUsersModel.Result?
    
    @IBOutlet weak var userLargImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userPhoneNumber: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

      userLargImage.image = UIImage(named: "\(randomUser?.picture.large)")
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
