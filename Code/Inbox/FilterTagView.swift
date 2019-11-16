import UIKit
import SwiftyPickerPopover

protocol FilterTagViewDelegate
{
    func tagFiltered(tagsList:Set<String>)
}

class FilterTagView: UIView
{
    @IBOutlet weak var createTagAlertView: UIView!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var tagTextView: UITextView!

    var selectedTags = Set<String>()

    var delegate:FilterTagViewDelegate?
    
    var tagsList = Array<Tag>()

    lazy var tagNames:Array<String> =
    {
        self.tagsList = Tag.getAllTags()
        
        let tagNamesList = self.tagsList.map({ (tag) -> String in
            
            return tag.tagName ?? ""
        })
                
        return tagNamesList
    }()
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        if #available(iOS 13.0, *)
        {
            overrideUserInterfaceStyle = .light
        }
        
        self.loadSelectedTags()
    }
    
    func loadSelectedTags()
    {
        var text = ""
        
        for tagName in selectedTags
        {
            if text == ""
            {
                text = tagName
            }
            else
            {
                text = text + "," + tagName
            }
        }
        
        self.tagTextView.text = text
    }
    
    class func instanceFromNib(delegate delegate_:FilterTagViewDelegate) -> FilterTagView
    {
        let filterTagView = UINib(nibName:"FilterTagView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! FilterTagView
        
        filterTagView.delegate = delegate_
                
        return filterTagView
    }
    
   @IBAction func applyTagButton_Tapped(_ sender: Any)
   {
      if let delegate = self.delegate
      {
        delegate.tagFiltered(tagsList:self.selectedTags)
      }
    
      self.dismissView()
   }

    @IBAction func clearButton_Tapped(_ sender: Any)
    {
        self.selectedTags.removeAll()
        
        self.loadSelectedTags()
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

extension FilterTagView:UITextViewDelegate
{
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
    {
        self.presentPopoverFromView(textView)
        
        return false
    }
    
    func presentPopoverFromView(_ textView: UITextView)
    {
        let picker = StringPickerPopover(title:"Select Tag", choices:self.tagNames)
        
        _ = picker.setValueChange(action: { _, _, selectedString in
            
        })
             
        _ = picker.setDoneButton(action: { popover, selectedRow, selectedString in
                
            self.selectedTags.insert(selectedString)

            self.loadSelectedTags()

            return
            
            if self.selectedTags.contains(selectedString)
            {
                self.selectedTags.remove(selectedString)
            }
            else
            {
                self.selectedTags.insert(selectedString)
            }
            
            self.loadSelectedTags()
        })
            
        _ = picker.setCancelButton(action: {_, _, _ in})
        
        picker.appear(originView:textView, baseViewController:(self.delegate as! UIViewController))
    }
}
