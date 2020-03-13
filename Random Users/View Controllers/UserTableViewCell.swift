
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
    
    var indexPath: IndexPath?
    
    func updateViews() {
        
        if let user = user {
            
            var punctuatedTitle = user.title.capitalized
            if punctuatedTitle == "Mr" || punctuatedTitle == "Mrs" || punctuatedTitle == "Ms" {
                punctuatedTitle = "\(punctuatedTitle)."
            }
            
            userNameLabel.text = "\(punctuatedTitle) \(user.firstName.capitalized) \(user.lastName.capitalized)"
        }        
    }
    
    override func prepareForReuse() {
        userImage.image = nil
        indexPath = nil
        super.prepareForReuse()
    }
}
