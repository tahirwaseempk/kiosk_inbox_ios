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
    
    func loadCell(chatModel:UserContact)
    {
        if (chatModel.firstName == "" && chatModel.lastName == ""){
            self.titleLbl.text = chatModel.phoneNumber
        } else {
            self.titleLbl.text = (chatModel.firstName ?? "") + " " + (chatModel.lastName ?? "")
        }
    }
    
    func reset()
    {
        self.titleLbl.text = ""
        
        self.selectionImageView?.isHighlighted = false
    }
    
}
