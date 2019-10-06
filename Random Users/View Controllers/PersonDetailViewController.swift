//
//  PersonDetailViewController.swift
//  Random Users
//
//  Created by Joshua Sharp on 10/4/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class PersonDetailViewController: UIViewController {

    var person: Person?
    var personController: PersonController?
    @IBOutlet weak var nameL: UILabel!
    @IBOutlet weak var phoneL: UILabel!
    @IBOutlet weak var emailL: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        // Do any additional setup after loading the view.
    }
    
    private func updateViews() {
        guard self.isViewLoaded,
            let person = person else { return }
        let name = "\(person.name.title) \(person.name.first) \(person.name.last)"
        nameL.text = name
        phoneL.text = person.phone
        emailL.text = person.email
        photoImageView.downloaded(from: person.picture.large)
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
