
import UIKit

class CollectionCell: UICollectionViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var tabName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backView.layer.cornerRadius = 10
        backView.backgroundColor = UIColor.lightGray
        
        tabName.textColor = UIColor.white
    }
}
