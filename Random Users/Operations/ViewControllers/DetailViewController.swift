//
//  DetailViewController.swift
//  Random Users
//
//  Created by Gladymir Philippe on 9/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var person: User? {
        didSet {
            updateViews()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()

        // Do any additional setup after loading the view.
    }
    
   @IBOutlet weak var personImage: UIImageView!
    @IBOutlet weak var personNameLabel: UILabel!
    @IBOutlet weak var personPhoneLabel: UILabel!
    @IBOutlet weak var personEmailLabel: UILabel!
    
    private func updateViews() {
        if let person = person {
            print("Person Found \(person.name.fullName)")
            
            personNameLabel?.text = person.name.fullName
            personPhoneLabel?.text = person.phone
            personEmailLabel?.text = person.email
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
