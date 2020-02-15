//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Austin Potts on 2/14/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    
    var usercontroller: UserController?
    
    var user: User? {
        didSet{
            updateViews()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    
    func updateViews() {
        guard isViewLoaded,
        let user = user else {return}
               
        title = user.name.first.capitalized + " " + user.name.last.capitalized
        userNameLabel.text = user.name.first
        userEmailLabel.text = user.email
        guard let imageData = try? Data(contentsOf: user.picture.large) else {fatalError()}
        userImage.image = UIImage(data: imageData)
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
