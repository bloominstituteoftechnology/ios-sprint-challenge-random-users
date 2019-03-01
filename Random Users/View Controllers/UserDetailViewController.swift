//Frulwinn

import UIKit

class UserDetailViewController: UIViewController {
    
    //MARK: - Properties
    var user: User?
    var userController: UserController?
    
    //MARK: - Outlets
    @IBOutlet weak var largeImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
