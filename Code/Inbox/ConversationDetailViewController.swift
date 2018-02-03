import UIKit

class ConversationDetailViewController: UIViewController, ConversationListingTableCellProtocol
{
    @IBOutlet weak var sendTextField: UITextField!
    @IBOutlet weak var messageFromLabel: UILabel!
    @IBOutlet weak var messageNumberLabel: UILabel!
    @IBOutlet weak var shortCodeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var closeView: UIView!
    
    @IBAction func closeButtonTapped(_ sender: Any)
    {
        self.closeView.frame = self.view.bounds
        
        self.view.addSubview(self.closeView)
    }
    
    @IBAction func closeViewDismisssButtonTapped(_ sender: Any)
    {
        self.closeView.removeFromSuperview()
    }
    
    var delegate:ConversationDetailViewControllerProtocol? = nil
    
    var tableViewDataSource:MessageTableViewDataSource? = nil
    
    var selectedConversation:Conversation! = nil
    
    var isShowActivityIndicator:Bool = false

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.sendTextField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
        
        tableViewDataSource = MessageTableViewDataSource(tableview: tableView)
        
        tableView.dataSource = tableViewDataSource
        
        if self.selectedConversation != nil
        {
            _ = self.conversationSelected(conversation: self.selectedConversation)
        }
     }
    
    @IBAction func backButton_Tapped(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func optOut_Tapped(_ sender: Any)
    {
        if (self.selectedConversation == nil)
        {
            let alert = UIAlertController(title: "Warning", message: "Please select conversation first.", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            ProcessingIndicator.show()
            
            User.optOutFromConversation(conversation: self.selectedConversation, completionBlockSuccess: { (status: Bool) -> (Void) in
                
                DispatchQueue.global(qos: .background).async
                {
                    DispatchQueue.main.async
                    {
                        ProcessingIndicator.hide()
                        
                        if status == true
                        {
                            let alert = UIAlertController(title: "Message", message: "Number has been successfully been opted out.", preferredStyle: UIAlertControllerStyle.alert)
                            
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            
                            self.present(alert, animated: true, completion: nil)
                        }
                        else if status == false
                        {
                            let alert = UIAlertController(title: "Error", message: "Number failed to opt out from list.", preferredStyle: UIAlertControllerStyle.alert)
                            
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }, andFailureBlock: { (error: Error?) -> (Void) in
                
                DispatchQueue.global(qos: .background).async
                {
                    DispatchQueue.main.async
                    {
                        ProcessingIndicator.hide()
                                
                        let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            })
        }
    }
    
    @IBAction func deleteMessage_Tapped(_ sender: Any)
    {
        if (self.selectedConversation == nil)
        {
            let alert = UIAlertController(title: "Warning", message: "Please select conversation first.", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            ProcessingIndicator.show()
            
            User.deleteLocalConversation(conversation: self.selectedConversation, completionBlockSuccess: { (status: Bool) -> (Void) in
                
                DispatchQueue.global(qos: .background).async
                {
                    DispatchQueue.main.async
                    {
                        
                        //ProcessingIndicator.hide()
                        
                        if status == true
                        {
                            
                            if let delegate = self.delegate
                            {
                                delegate.conversationRemoved()
                            }
                            
                            self.navigationController?.popViewController(animated: true)
                        }
                        else if status == false
                        {
                            let alert = UIAlertController(title: "Error", message: "Conversation has been failed to be deleted.", preferredStyle: UIAlertControllerStyle.alert)
                            
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }, andFailureBlock: { (error: Error?) -> (Void) in
                
                DispatchQueue.global(qos: .background).async
                {
                    DispatchQueue.main.async
                    {
                        ProcessingIndicator.hide()
                        
                        let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            })
        }
    }
    
    @IBAction func sendMessage_Tapped(_ sender: Any)
    {
        if (self.selectedConversation == nil)
        {
            let alert = UIAlertController(title: "Send Message", message: "Please select conversation first.", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            if (self.sendTextField.text?.isEmpty == false)
            {
                ProcessingIndicator.show()
                
                _ = self.sendMessageToConversation(conversation: self.selectedConversation, message: self.sendTextField.text!)
            } else
            {
                let alert = UIAlertController(title: "Send Message", message: "Please enter message.", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func conversationSelected(conversation:Conversation?) -> Bool
    {
        self.selectedConversation = conversation
        
        if self.selectedConversation != nil
        {
            if UIDevice.current.userInterfaceIdiom == .pad
            {
                self.messageFromLabel.text =  (self.selectedConversation.firstName)! + " " + (self.selectedConversation.lastName)!
                
                self.messageNumberLabel.text = self.selectedConversation.mobile
            }
            else
            {
                if self.selectedConversation.firstName?.isEmpty == false && self.selectedConversation.firstName?.isEmpty == false
                {
                    self.messageFromLabel.text =  self.selectedConversation.mobile//(self.selectedConversation.firstName)! + " " + (self.selectedConversation.lastName)!
                    
                    self.messageNumberLabel.text = self.selectedConversation.mobile
                }
                else
                {
                    self.messageFromLabel.text =   self.selectedConversation.mobile
                    
                    self.messageNumberLabel.text = ""
                }
            }
                        
            self.shortCodeLabel.text = self.selectedConversation.shortcodeDisplay
        }
        else
        {
            self.messageFromLabel.text =  ""
            
            self.messageNumberLabel.text = ""
            
            self.shortCodeLabel.text = ""
        }
        
        self.sendTextField.text = ""
        
        _ = self.tableViewDataSource?.loadConversation(conversation_: self.selectedConversation)
        
        return true
    }
}

extension ConversationDetailViewController
{
    func sendMessageToConversation(conversation: Conversation, message: String) -> Bool
    {
        User.sendUserMessage(conversation: conversation, message: message, completionBlockSuccess: { (sendMessaage:Message) -> (Void) in
            
            DispatchQueue.global(qos:.background).async
            {
                DispatchQueue.main.async
                {
                    ProcessingIndicator.hide()
                    
                    self.sendTextField.text = ""
                    
                    _ = self.tableViewDataSource?.reloadControls()
                }
            }
            
        }) { (error:Error?) -> (Void) in
            
            DispatchQueue.global(qos:.background).async
            {
                DispatchQueue.main.async
                {
                    ProcessingIndicator.hide()
                    
                    self.sendTextField.text = ""
                    
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription , preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
        return true
    }
}

extension ConversationDetailViewController:UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        sendTextField.resignFirstResponder()
        
        return true;
    }
}
