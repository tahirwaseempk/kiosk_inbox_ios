import UIKit

let ADD_TAG_TITLE = "Add"

protocol ContactTagTableViewCellDelegate
{
    func addTagTapped()
    func deleteTagTapped(_ tagToDelete:String)
}

class ContactTagTableViewCell: UITableViewCell, TagListViewDelegate
{
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var tagListView: TagListView!
    
    var delegate:ContactTagTableViewCellDelegate?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        tagListView.textFont = UIFont.systemFont(ofSize: 24)
        tagListView.alignment = .left
        tagListView.delegate = self
        tagListView.addTag(ADD_TAG_TITLE)
        tagListView.addTag("Thanos")
        tagListView.addTag("Technology")
        tagListView.addTag("Shield")
        tagListView.addTag("App")
        tagListView.addTag("Endgame")
        tagListView.addTag("Thanos")
        tagListView.addTag("Technology")
        tagListView.addTag("Shield")
        tagListView.addTag("App")
        tagListView.addTag("Endgame")
    }
    
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView)
    {
        if title == ADD_TAG_TITLE
        {
            if let delegate = self.delegate
            {
                delegate.addTagTapped()
            }
        }
        else
        {
            if let delegate = self.delegate
            {
                delegate.deleteTagTapped(title)
            }
        }
    }
}
