import UIKit

protocol FilterTagViewDelegate
{
    func tagFiltered(tagsList:Set<String>)
}

class FilterTagView: UIView
{
    @IBOutlet weak var createTagAlertView: UIView!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var tagListView: TagListView!

    var selectedTags = Set<String>()

    var delegate:FilterTagViewDelegate?
    
    let tags = Tag.getAllTags()
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        if #available(iOS 13.0, *)
        {
            overrideUserInterfaceStyle = .light
        }
        
        self.loadAllTags()
    }
    
    func loadAllTags()
    {
        tagListView.removeAllTags()
        
        tagListView.addTag(ADD_TAG_TITLE)
        
        for tag in self.tags
        {
            if let tagName = tag.tagName
            {
                let tagView = tagListView.addTag(tagName)
                
                if self.selectedTags.contains(tagName)
                {
                    tagView.isSelected = true
                }
                else
                {
                    tagView.isSelected = false
                }
            }
        }
    }
    
    class func instanceFromNib(delegate delegate_:FilterTagViewDelegate) -> FilterTagView
    {
        let filterTagView = UINib(nibName: "FilterTagView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! FilterTagView
        
        filterTagView.delegate = delegate_
                
        return filterTagView
    }
    
   @IBAction func applyTagButton_Tapped(_ sender: Any)
   {
      if let delegate = self.delegate
      {
        delegate.tagFiltered(tagsList:self.selectedTags)
      }
   }
    
   @IBAction func dismissTagAlertButton_Tapped(_ sender: Any)
   {
       self.dismissView()
   }
   
    func dismissView()
    {
        self.removeFromSuperview()
    }
        
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        roundControls()
    }
    
    func roundControls()
    {
        self.applyButton.layer.cornerRadius = self.applyButton.bounds.size.height / 2.0
    }
}

extension FilterTagView:TagListViewDelegate
{
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView)
    {
        if self.selectedTags.contains(title)
        {
            self.selectedTags.remove(title)
            
            tagView.isSelected = false
        }
        else
        {
            self.selectedTags.insert(title)
            
            tagView.isSelected = true
        }
    }
}
