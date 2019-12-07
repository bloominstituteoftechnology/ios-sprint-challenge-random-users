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
        updateViews()

        // Do any additional setup after loading the view.
    }
    
    
    func updateViews(){
        
         print("Passed the assigning")
        
        guard let firstName = user?.name.first,
            let lastName = user?.name.last,
            let age = user?.dob.age,
            let email = user?.email,
            let name = userName,
            let image = user?.picture.large else { return }
       
       userName.text = "\(firstName) \(lastName)"
        userDOB.text = "\(age) years old"
        userEmail.text = "Email: \(email)"
        
        
        
         URLSession.shared.dataTask(with: (image)) { (data, _, error) in
                   
                   if let error = error {
                       NSLog("Error fetching images: \(error)")
                       return
                   }
                   
                   guard let data = data else { return }
                   DispatchQueue.main.async {
                       self.userLargeImage.image = UIImage(data: data)
                   }
               }.resume()
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


