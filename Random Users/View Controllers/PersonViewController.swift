//
//  PersonViewController.swift
//  Random Users
//
//  Created by Cameron Collins on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class PersonViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    //MARK: - Properties
    var user: Result?
    var networkController: NetworkController?
    static let identifier = "userSegue"
    
    //MARK: - Outlets
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    
    //MARK: - Custom Functions
    func updateViews() {
        guard let tempUser = user else {
            print("Bad User in \(#function)")
            return
        }
        
        let url = URL(string: tempUser.picture.large)
        guard let tempURL = url else {
            print("Bad URL in \(#function)")
            return
        }
        
        networkController?.fetchImageLarge(imageURL: tempURL, completion: { (data) in
            DispatchQueue.main.async {
                guard let imageData = data else {
                    print("Bad image Data \(#function)")
                    return
                }
                
                self.personImageView.image = UIImage(data: imageData)
            }
        })
        
        if let name = user?.name {
            nameLabel.text = "\(name.first) \(name.last)"
        }
        
        phoneLabel.text = user?.phone
        emailLabel.text = user?.email
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
