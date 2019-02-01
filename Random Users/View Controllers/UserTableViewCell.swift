
import UIKit

class UserTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "usercell"
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    private func updateViews() {
        
        // Check to make sure there is a user
        guard let user = user else { return }
        
        userNameLabel.text = "\(User.UserKeys.Name.title) \(User.UserKeys.Name.first) \(User.UserKeys.Name.last)"
        
        guard let url = URL(string: user.picture), let imageData = try? Data(contentsOf: url) else { return }
        
        userImage.image = UIImage(data: imageData)
        
    }
    
    
}
