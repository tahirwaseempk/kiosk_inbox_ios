import UIKit

class ContactsListTableViewCell: UITableViewCell
{
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var selectionImageView: UIImageView!
    @IBOutlet weak var titleLeadingConstraintWithImage: NSLayoutConstraint!
    @IBOutlet weak var titleLeadingConstraintWithSuperView: NSLayoutConstraint!

    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    func loadCell(chatModel:Contact)
    {
        self.titleLbl.text = chatModel.contacName
    }
    
}
