import UIKit

let ADD_TAG_TITLE = "Add"

protocol ContactTagTableViewCellDelegate
{
    func addTagTapped()
    func deleteTagTapped(_ tagToDelete:Tag)
}

class ContactTagTableViewCell: UITableViewCell, TagListViewDelegate
{
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var tagListView: TagListView!
    
    var contact:UserContact!
    var delegate:ContactTagTableViewCellDelegate?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        tagListView.textFont = UIFont.systemFont(ofSize:18)
        
        tagListView.alignment = .left
        
        tagListView.delegate = self
    }
    
    func loadCell(fromContact:UserContact)
    {
        self.contact = fromContact

        tagListView.removeAllTags()
        
        tagListView.addTag(ADD_TAG_TITLE)

        if let tags = fromContact.tags
        {
            for tag in Array(tags)
            {
                if let tagName = (tag as! Tag).tagName
                {
                    let tag = tagListView.addTag(tagName)
                    
                   // tag.enableRemoveButton =  true
                }
            }
        }
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
            if let delegate = self.delegate, let tags = self.contact.tags
            {
                for tag in tags
                {
                    if title == (tag as! Tag).tagName
                    {
                        delegate.deleteTagTapped((tag as! Tag))
                        
                        break
                    }
                }
            }
        }
    }
}
