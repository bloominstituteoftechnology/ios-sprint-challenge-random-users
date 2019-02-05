import UIKit

class RandomUserTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var randomUserCellImageView: UIImageView!
    
    @IBOutlet weak var randomUserCellNameLabel: UILabel!
}
