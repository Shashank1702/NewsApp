
import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var headerContainerView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var autherName: UILabel!
    @IBOutlet weak var publishedDate: UILabel!
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var footerContainerView: UIView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var content: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        backView.layer.cornerRadius = 12
        backView.backgroundColor = UIColor(red: 6/255.0, green: 125/255.0, blue: 255/255.0, alpha: 1)
    }
    
}
