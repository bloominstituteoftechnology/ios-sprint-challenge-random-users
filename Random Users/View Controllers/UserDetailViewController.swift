import UIKit

class UserDetailViewController: UIViewController {
    
    //MARK: - Properties
    var user: User?
    
    //MARK: - Outlets
    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard isViewLoaded,
            let user = user else { return }
        
        phoneLabel.text = user.phone
        emailLabel.text = user.email
        

    }
    
}
