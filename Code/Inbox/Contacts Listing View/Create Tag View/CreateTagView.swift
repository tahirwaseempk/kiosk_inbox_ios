import UIKit

protocol CreateTagViewDelegate
{
    func tagCreated()
}

class CreateTagView: UIView, UITextFieldDelegate
{
    @IBOutlet weak var createTagAlertView: UIView!
    @IBOutlet weak var tagNameTextField: UITextField!
    @IBOutlet weak var applyButton: UIButton!
    
    var contacts = Array<UserContact>()

    var delegate:CreateTagViewDelegate?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
    }
    
    class func instanceFromNib(delegate delegate_:CreateTagViewDelegate) -> CreateTagView
    {
        let view = UINib(nibName: "CreateTagView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CreateTagView
        
        view.delegate = delegate_
                
        return view
    }
    
   @IBAction func applyTagButton_Tapped(_ sender: Any)
   {
      if let tageName = tagNameTextField.text, tageName.count > 0
      {
          self.createAndAssignTag(tageName:tageName)
      }
      else
      {
          let alert = UIAlertController(title:"Tage Name Missing",message:"Please enter valid tag name",preferredStyle: UIAlertControllerStyle.alert)
          
          let okAction = UIAlertAction(title:"Ok", style:.default) { (action:UIAlertAction) in
              
          }
          
          alert.addAction(okAction)
          
          if let delegate = self.delegate as? UIViewController
          {
             delegate.present(alert,animated:true,completion:nil)
          }
      }
   }
   
    func createAndAssignTag(tageName:String)
    {
        ProcessingIndicator.show()

        if let delegate = self.delegate as? UIViewController
        {
            Tag.createTagAPI(tagName:tageName, contacts:self.contacts ,completionBlockSuccess: { (status:Bool) -> (Void) in
                
                DispatchQueue.global(qos: .background).async
                {
                    DispatchQueue.main.async
                    {
                        self.delegate!.tagCreated()

                        ProcessingIndicator.hide()
                        
                        let alert = UIAlertController(title:"Success",message:"Tag Created & Assigned To Selected Contacts",preferredStyle: UIAlertControllerStyle.alert)
                        
                        let okAction = UIAlertAction(title:"OK", style:.default) { (action:UIAlertAction) in
                            
                            self.dismissView()
                        }
                        
                        alert.addAction(okAction)
                        
                        delegate.present(alert,animated:true,completion:nil)
                    }
                }
                
            }) { (error:Error?) -> (Void) in
                
                DispatchQueue.global(qos: .background).async
                {
                    DispatchQueue.main.async
                    {
                        ProcessingIndicator.hide()
                        
                        let alert = UIAlertController(title:"Error",message:error?.localizedDescription,preferredStyle: UIAlertControllerStyle.alert)
                        
                        let okAction = UIAlertAction(title:"OK", style:.default) { (action:UIAlertAction) in
                            
                        }
                        
                        alert.addAction(okAction)
                        
                        delegate.present(alert,animated:true,completion:nil)
                    }
                }
            }
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
