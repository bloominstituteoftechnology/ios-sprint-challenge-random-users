//
//  RandomUserDetailViewController.swift
//  Random Users
//
//  Created by TuneUp Shop  on 2/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class RandomUserDetailViewController: UIViewController {

    var randomUser: RandomPerson?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        randomUserDetailNameLabel.text = randomUser?.fullName
        randomUserDetailEmailLabel.text = randomUser?.email
        randomUserDetailPhoneLabel.text = randomUser?.phone
        randomUserDetailImageView.loadImageFrom(url: URL(string: (randomUser?.large)!)!)

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - IB Outlets
    
    @IBOutlet weak var randomUserDetailImageView: UIImageView!
    
    @IBOutlet weak var randomUserDetailNameLabel: UILabel!
    
    @IBOutlet weak var randomUserDetailPhoneLabel: UILabel!
    
    @IBOutlet weak var randomUserDetailEmailLabel: UILabel!
}
