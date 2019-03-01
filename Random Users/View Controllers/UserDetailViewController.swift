//Frulwinn

import UIKit

class UserDetailViewController: UIViewController {
    
    //MARK: - Properties
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: - Outlets
    @IBOutlet weak var largeImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViews()
    }
    
    func updateViews() {
        guard isViewLoaded else { return }
        guard let user = user else { return }
        
        nameLabel.text = "\(user.title.capitalized) \(user.firstName.capitalized) \(user.lastName.capitalized)"
        phoneLabel.text = user.phone
        emailLabel.text = user.email
        
        guard let url = URL(string: user.picture),
            let imageData = try? Data(contentsOf: url) else { return }
        largeImage.image = UIImage(data: imageData)
    }

}
