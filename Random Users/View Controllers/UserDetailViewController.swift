
import UIKit

class UserDetailViewController: UIViewController {
    
    // Instance of model user
    var user: User?
    
    // Called just before view controller appears
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Check that view is loaded
        guard isViewLoaded else { return }
        
        guard let user = user else { return }
        
        // Populate the labels and image
        var punctuatedTitle = user.title.capitalized
        if punctuatedTitle == "Mr" || punctuatedTitle == "Mrs" || punctuatedTitle == "Ms" {
            punctuatedTitle = "\(punctuatedTitle)."
        }
        
        userNameLabel.text = "\(punctuatedTitle) \(user.firstName.capitalized) \(user.lastName.capitalized)"
        userPhoneLabel.text = user.phone
        userEmailLabel.text = user.email
        
        guard let url = URL(string: user.picture), let imageData = try? Data(contentsOf: url) else { return }
        
        userImage.image = UIImage(data: imageData)
        
    }
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userPhoneLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    
}
