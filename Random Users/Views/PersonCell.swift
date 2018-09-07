
import Foundation
import UIKit
import CoreData

class PersonCell:UITableViewCell
{
	@IBOutlet weak var photoView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!

	var person:Person! {
		didSet {
			nameLabel.text = person.name
		}
	}

}
