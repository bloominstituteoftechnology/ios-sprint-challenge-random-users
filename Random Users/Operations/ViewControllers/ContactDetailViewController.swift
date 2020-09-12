//
//  ContactDetailViewController.swift
//  Random Users
//
//  Created by Gladymir Philippe on 9/11/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {
    
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var contactEmailLabel: UILabel!
    @IBOutlet weak var contactPhoneNumberLabel: UILabel!
    
    var contact: Contact?
    var apiController: APIController?
    let cache = Cache<String, Data>()

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        // Do any additional setup after loading the view.
    }
    
     override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           view.backgroundColor = UIColor(red: 206, green: 218, blue: 218)
           navigationController?.navigationBar.backgroundColor = UIColor(red: 206, green: 218, blue: 218)
       }
    
    private func updateViews(){
        guard let contact = contact else { return }
        contactNameLabel.text = "\(contact.name.title) \(contact.name.first) \(contact.name.last)"
        contactEmailLabel.text = "\(contact.email)"
        contactPhoneNumberLabel.text = "\(contact.phone)"

        if let cachedImage = cache.getValue(for: contact.email),
            let image = UIImage(data: cachedImage){
            contactImageView.image = image
        }
        getImage()
    }

    private func getImage(){
        guard let contact = contact else { return }
        apiController?.downloadImage(at: contact.picture.large , completion: { (result) in
            do{
                let imageString = try result.get()
                let image = UIImage(data: imageString)
                self.cache.storeInCache(value: imageString, for: contact.email)
                DispatchQueue.main.async {
                    self.contactImageView.image = image
                }
            } catch{
                print("Error getting contact's image")
            }
        })
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
