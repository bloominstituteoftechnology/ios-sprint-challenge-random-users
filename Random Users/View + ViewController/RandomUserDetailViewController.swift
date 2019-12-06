//
//  RandomUserDetailViewController.swift
//  Random Users
//
//  Created by Rick Wolter on 12/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class RandomUserDetailViewController: UIViewController {
    
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userDOB: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    
    @IBOutlet weak var userLargeImage: UIImageView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    func updateViews(){
        
        guard let firstName = user?.name.first,
            let lastName = user?.name.last,
            let age = user?.dob.age,
            let email = user?.email,
            let name = userName,
            let image = user?.picture.large else { return }
        name.text = "\(firstName) \(lastName)"
        userDOB.text = "\(age) years old"
        userEmail.text = "Email: \(email)"
        
        
        
        //Networking to fetch image
        
        
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
