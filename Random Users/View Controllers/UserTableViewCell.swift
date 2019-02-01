
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
    
    func updateViews() {
        
        if let user = user {
            
            var punctuatedTitle = user.title.capitalized
            if punctuatedTitle == "Mr" || punctuatedTitle == "Mrs" || punctuatedTitle == "Ms" {
                punctuatedTitle = "\(punctuatedTitle)."
            }
            
            userNameLabel.text = "\(punctuatedTitle) \(user.firstName.capitalized) \(user.lastName.capitalized)"
            
            guard let url = URL(string: user.picture),
            let imageData = try? Data(contentsOf: url) else { return }
            
            userImage.image = UIImage(data: imageData)
        }
        
    }
    
    
}
