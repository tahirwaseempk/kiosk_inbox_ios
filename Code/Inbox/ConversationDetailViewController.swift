import UIKit

class ConversationDetailViewController: UIViewController, ConversationListingTableCellProtocol
{
    @IBOutlet weak var sendTextField: UITextField!
    @IBOutlet weak var messageFromLabel: UILabel!
    @IBOutlet weak var messageNumberLabel: UILabel!
    @IBOutlet weak var shortCodeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var closeView: UIView!
    
    var scheduleAppointmentViewController:ScheduleAppointmentViewController!

    var delegate:ConversationDetailViewControllerProtocol? = nil
    
    var tableViewDataSource:MessageTableViewDataSource? = nil
    
    var selectedConversation:Conversation! = nil
    
    var isShowActivityIndicator:Bool = false
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
        self.sendTextField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
        self.sendTextField.delegate = self
        
        tableViewDataSource = MessageTableViewDataSource(tableview: tableView)
        
        tableView.dataSource = tableViewDataSource
        
        if self.selectedConversation != nil
        {
            _ = self.conversationSelected(conversation: self.selectedConversation)
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        
        self.closeView.frame = self.view.bounds
        
        self.view.addSubview(self.closeView)
    }
    
    @IBAction func closeViewDismisssButtonTapped(_ sender: Any) {
        self.closeView.removeFromSuperview()
    }
    
    @IBAction func backButton_Tapped(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func scheduleAppointment_Tapped(_ sender: Any) {
        
        self.closeView.removeFromSuperview()
        
        self.scheduleAppointmentViewController = UIStoryboard(name: "ScheduleAppointment", bundle: nil).instantiateViewController(withIdentifier: "ScheduleAppointmentViewController") as! ScheduleAppointmentViewController
        
        if self.selectedConversation != nil
        {
            //            if self.selectedConversation.firstName?.isEmpty == false && self.selectedConversation.firstName?.isEmpty == false
            //            {
            //                self.scheduleAppointmentViewController.headerTitleString =  (self.selectedConversation.firstName)! + " " + (self.selectedConversation.lastName)!
            //            }
            //            else
            //            {
            self.scheduleAppointmentViewController.headerTitleString = self.selectedConversation.mobile!
            //            }
            
            self.scheduleAppointmentViewController.selectedConversation = self.selectedConversation
        }
        
        self.view.addSubview(self.scheduleAppointmentViewController.view)
        
        self.scheduleAppointmentViewController.view.frame = self.view.bounds
    }
    
    @IBAction func optOut_Tapped(_ sender: Any) {
        
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
    
    @IBAction func deleteMessage_Tapped(_ sender: Any) {
        
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
    
    @IBAction func sendMessage_Tapped(_ sender: Any) {
        
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
                
                _ = self.sendMessageToConversation(conversation: self.selectedConversation, message: self.sendTextField.text!, imageType: "", imageString: "")
            } else
            {
                let alert = UIAlertController(title: "Send Message", message: "Please enter message.", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func attachment_Tapped(_ sender: Any) {
        
        if (self.selectedConversation == nil)
        {
            let alert = UIAlertController(title: "Send Message", message: "Please select conversation first.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
}

extension ConversationDetailViewController {
    
    func convertImageTobase64(format: String, image:UIImage) -> String? {
        
        var imageData: Data?
        
        if (format == "jpg") {
            imageData = UIImageJPEGRepresentation(image, 0)
        }
        else if (format == "png") {
            imageData = UIImagePNGRepresentation(image)
        }
        //##################################################################################//
        //##################################################################################//
        //##################################################################################//
        //        return imageData?.base64EncodedString()
        //********************************************************************************//
        //********************************************************************************//
        //********************************************************************************//
        //       let myBase64Data = imageData?.base64EncodedData(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
        //       let resultData = NSData(base64Encoded: myBase64Data!, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!
        //       let resultNSString = resultData.base64EncodedString()
        //       let resultNSString = NSString(data: resultData as Data, encoding: String.Encoding.utf8.rawValue)
        //       let resultString = resultNSString! as String
        //       return resultNSString
        //********************************************************************************//
        //********************************************************************************//
        //********************************************************************************//
        //        return imageData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        //        return imageData?.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
        //##################################################################################//
        //##################################################################################//
        //##################################################################################//
        let base64Str = imageData?.base64EncodedString()
        let utf8str = base64Str?.data(using: String.Encoding.utf8)
        let base64Encoded = utf8str?.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
        let resultStr = base64Encoded! as String
        return resultStr
        //##################################################################################//
        //##################################################################################//
        //##################################################################################//
    }
    
    func getImageFromBase64(base64:String) -> UIImage {
        
        let data = Data(base64Encoded: base64)
        return UIImage(data: data!)!
    }
    
    func base64ToBase64url(base64: String) -> String {
        let base64url = base64
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
        return base64url
    }
    
    func base64urlToBase64(base64url: String) -> String {
        var base64 = base64url
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        if base64.count % 4 != 0 {
            base64.append(String(repeating: "=", count: 4 - base64.count % 4))
        }
        return base64
    }
    
    // MARK: - Stings Extensions Base64 Methods
    //extension String {
    //
    //    func fromZBase64() -> String? {
    //        guard let data = Data(base64Encoded: self) else {
    //            return nil
    //        }
    //
    //        return String(data: data, encoding: .utf8)
    //    }
    //
    //    func toZBase64() -> String {
    //        return Data(self.utf8).base64EncodedString()
    //    }
    //}
    
}


// MARK: - UIImagePickerControllerDelegate Methods
extension ConversationDetailViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate  {
   
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if (info[UIImagePickerControllerOriginalImage] as? UIImage) != nil {
            
            var selectedImageType:String = ""
            let assetPath = info[UIImagePickerControllerReferenceURL] as! NSURL
            
            if (assetPath.absoluteString?.hasSuffix("JPG"))! {
                selectedImageType = "jpg"
            }
            else if (assetPath.absoluteString?.hasSuffix("PNG"))! {
                selectedImageType = "png"
            }
                
            else {
                selectedImageType = ""
                
                let alert = UIAlertController(title: "Error Message", message: "Selected image type not supported.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                dismiss(animated: true, completion: nil)
            }
            
            
            let base64String = convertImageTobase64(format: selectedImageType, image: (info[UIImagePickerControllerEditedImage] as? UIImage)!)
            //base64String = base64String?.replacingOccurrences(of: "+", with: "%2B")
            
            //Call Web Service to Send Message
            if base64String != ""
            {
                if (selectedImageType != "") {
                    ProcessingIndicator.show()
                    _ = self.sendMessageToConversation(conversation: self.selectedConversation, message: "", imageType: selectedImageType, imageString: base64String!)
                    
                } else {
                    
                    let alert = UIAlertController(title: "Error Message", message: "Selected image type not supported.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - Service Calling Methods
extension ConversationDetailViewController {
    
    func conversationSelected(conversation:Conversation?) -> Bool {
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
    
    func sendMessageToConversation(conversation: Conversation, message: String, imageType: String, imageString: String) -> Bool {
        
        
        var paramsDic = Dictionary<String, Any>()
        paramsDic["message"] = message
        paramsDic["attachment"] = imageString
        paramsDic["attachemntFileSuffix"] = imageType
        
        User.sendUserMessage(conversation: conversation, paramsJson: paramsDic, completionBlockSuccess: { (sendMessaage:Message) -> (Void) in
            
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

// MARK: - UITextFieldDelegate Methods
extension ConversationDetailViewController:UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        sendTextField.resignFirstResponder()
        
        return true;
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)

        let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
        let filtered = string.components(separatedBy: cs).joined(separator: "")
        let isAllowed = (string == filtered)
        
        if isAllowed == false {
            return false
        }
        
        if str.count > 160 {
            return false
        }
        
        return true
    }
    
}
