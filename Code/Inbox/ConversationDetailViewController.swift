import UIKit

class ConversationDetailViewController: UIViewController, ConversationListingTableCellProtocol
{
    @IBOutlet weak var sendTextField: UITextField!
    @IBOutlet weak var messageFromLabel: UILabel!
    @IBOutlet weak var messageNumberLabel: UILabel!
    @IBOutlet weak var shortCodeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var closeView: UIView!
    
    /////////////////////////////////////////////////
    @IBOutlet weak var cross_Button: UIButton!
    @IBOutlet weak var delete_Button: UIButton!
    @IBOutlet weak var Optout_Button: UIButton!
    @IBOutlet weak var schedule_Button: UIButton!
    /////////////////////////////////////////////////
    
    @IBOutlet weak var header_View: UIView!
    var scheduleAppointmentViewController:ScheduleAppointmentViewController!
    
    var delegate:ConversationDetailViewControllerProtocol? = nil
    
    var tableViewDataSource:MessageTableViewDataSource? = nil
    
    var selectedConversation:Conversation! = nil
    
    var isShowActivityIndicator:Bool = false
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        switch environment {
        case .texting_Line:
            if UIDevice.current.userInterfaceIdiom == .pad {
                header_View.backgroundColor = GrayHeaderColor
            } else {
                header_View.backgroundColor = AppBlueColor
            }
            cross_Button.backgroundColor = AppBlueColor
            delete_Button.backgroundColor = AppBlueColor
            Optout_Button.backgroundColor = AppBlueColor
            schedule_Button.backgroundColor = AppBlueColor

        case .sms_Factory:
            if UIDevice.current.userInterfaceIdiom == .pad {
                header_View.backgroundColor = GrayHeaderColor
            } else {
                header_View.backgroundColor = AppBlueColor
            }
            cross_Button.backgroundColor = AppBlueColor
            delete_Button.backgroundColor = AppBlueColor
            Optout_Button.backgroundColor = AppBlueColor
            schedule_Button.backgroundColor = AppBlueColor
            
        case .fan_Connect:
            if UIDevice.current.userInterfaceIdiom == .pad {
                header_View.backgroundColor = GrayHeaderColor
            } else {
                header_View.backgroundColor = FanAppColor
            }
            cross_Button.backgroundColor = FanAppColor
            delete_Button.backgroundColor = FanAppColor
            Optout_Button.backgroundColor = FanAppColor
            schedule_Button.backgroundColor = FanAppColor
            
        case .photo_Texting:
            if UIDevice.current.userInterfaceIdiom == .pad {
                header_View.backgroundColor = GrayHeaderColor
            } else {
                header_View.backgroundColor = PhotoAppColor
            }
            cross_Button.backgroundColor = PhotoAppColor
            delete_Button.backgroundColor = PhotoAppColor
            Optout_Button.backgroundColor = PhotoAppColor
            schedule_Button.backgroundColor = PhotoAppColor
        }
        
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
            
            self.scheduleAppointmentViewController.headerTitleString = "NUMBER SHOW KERNA"//self.selectedConversation.mobile!
            
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

    //##################################################################################//
    //##################################################################################//
    func getDataFromImage(format: String, imageE:UIImage) -> Data {

        var imageData: Data?
        
        if (format == "jpg" || format == "jpeg") {
            imageData = UIImageJPEGRepresentation(imageE, 1)!   // QUALITY min = 0 / max = 1
        }
        else if (format == "png") {
            imageData = UIImagePNGRepresentation(imageE)!
        }
        
        return imageData!
    }
    //##################################################################################//
    //##################################################################################//
    func getImageFromData(imageData: Data) -> UIImage {
       
        return UIImage(data: imageData)!

    }
    //##################################################################################//
    //##################################################################################//
    func getBase64StringFromImage(format: String, image:UIImage) -> String? {
        
        let imageData = self.getDataFromImage(format: format, imageE: image)
        
        let  base64String = imageData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 1))
        
        return base64String
    }
    
    //Not using
    func getImageFromBase64(base64:String) -> UIImage {
        
        let data = Data(base64Encoded: base64)
        return UIImage(data: data!)!
    }
    //Not using
    func base64ToBase64url(base64: String) -> String {
        let base64url = base64
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
        return base64url
    }
    //Not using
    func base64urlToBase64(base64url: String) -> String {
        var base64 = base64url
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        if base64.count % 4 != 0 {
            base64.append(String(repeating: "=", count: 4 - base64.count % 4))
        }
        return base64
    }
    
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
            
            //////////////////////////////////////////////////////////////////////////////
            var base64String = getBase64StringFromImage(format: selectedImageType, image: (info[UIImagePickerControllerOriginalImage] as? UIImage)!)
            base64String = self.base64ToBase64url(base64: base64String!)
            
            //base64String?.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)!
            ////////////////////////////////////////////////////////////////////////////////
            
            //Call Web Service to Send Message
            if base64String != ""
            {
                if (selectedImageType != "") {
                    ProcessingIndicator.show()
                    _ = self.sendMessageToConversation(conversation: self.selectedConversation, message: "MMS", imageType: selectedImageType, imageString: base64String!)
                    
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
                self.messageFromLabel.text = "FIRST LAST NAME" //(self.selectedConversation.firstName)! + " " + (self.selectedConversation.lastName)!
                
                self.messageNumberLabel.text = "MOBILE NUMBER" //self.selectedConversation.mobile
            }
            else
            {
                /*
                if self.selectedConversation.firstName?.isEmpty == false && self.selectedConversation.firstName?.isEmpty == false
                {
                    self.messageFromLabel.text = "MOBILE NUMBER" //self.selectedConversation.mobile
                    
                    self.messageNumberLabel.text = "MOBILE NUMBER" //self.selectedConversation.mobile
                }
                else
                {
                    self.messageFromLabel.text = "MOBILE NUMBER" //self.selectedConversation.mobile
                    
                    self.messageNumberLabel.text = ""
                }
                */
            }
            
            self.shortCodeLabel.text = "SHORT CODE" //self.selectedConversation.shortcodeDisplay
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
        paramsDic["attachmentFileSuffix"] = imageType
        
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
        
        if str.count > sendMessageMaxLength {
            return false
        }
        
        return true
    }
    
}
