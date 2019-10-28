import UIKit

protocol CreateTagViewDelegate
{
    func applyTagButton_Tapped()
}

class CreateTagView: UIView, UITextFieldDelegate
{
    @IBOutlet weak var createTagAlertView: UIView!
    @IBOutlet weak var tagNameTextField: UITextField!
    @IBOutlet weak var applyButton: UIButton!
    
    var delegate:CreateTagViewDelegate?
    
    class func instanceFromNib(delegate delegate_:CreateTagViewDelegate) -> CreateTagView
    {
        let view = UINib(nibName: "CreateTagView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CreateTagView
        
        view.delegate = delegate_
        
        return view
    }
    
   @IBAction func applyTagButton_Tapped(_ sender: Any)
   {
        if let delegate = self.delegate
        {
            delegate.applyTagButton_Tapped()
        }
   }
   
   @IBAction func dismissTagAlertButton_Tapped(_ sender: Any)
   {
       self.removeFromSuperview()
   }
   
   func textFieldDidEndEditing(_ textField: UITextField)
   {
       textField.resignFirstResponder()
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
