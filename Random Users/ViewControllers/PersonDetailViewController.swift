//
//  PersonDetailViewController.swift
//  Random Users
//
//  Created by Angel Buenrostro on 3/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class PersonDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.updateViews()
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
    // Mark: - Private
    
    func updateViews() {
        guard let person = self.person else { print("Cell has no person"); return }
        nameLabel.text = person.name
        phoneNumberLabel.text = person.phone
        emailLabel.text = person.email
        personImageView.image = largeImage
    }
    
    @IBOutlet weak var personImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    
    // MARK: - Properties
    
    var randomUserController: RandomUserController?
    var largeImage: UIImage?
    var person: Person? {
        didSet {
            DispatchQueue.main.async{
                self.updateViews()
            }
        }
    }
}
