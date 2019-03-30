import UIKit

class ConversationDetailViewController: UIViewController, ConversationListingTableCellProtocol
{
    @IBOutlet weak var sendTextField: UITextField!
    @IBOutlet weak var messageFromLabel: UILabel!
    @IBOutlet weak var messageNumberLabel: UILabel!
    @IBOutlet weak var shortCodeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var closeView: UIView!
    
    @IBOutlet weak var inputCharacterCountLabel: UILabel!
    
    /////////////////////////////////////////////////
    @IBOutlet weak var cross_Button: UIButton!
    @IBOutlet weak var delete_Button: UIButton!
    @IBOutlet weak var Optout_Button: UIButton! // Profile View
    @IBOutlet weak var schedule_Button: UIButton!

    @IBOutlet weak var sendButton: UIButton!
    
    // MARK: - Profile View Outlets
    @IBOutlet var profileV: UIView!
    @IBOutlet weak var profileNavView: UIView!
    
    @IBOutlet weak var profileHeadingLabel: UILabel!
    @IBOutlet weak var profileUsernameLabel: UILabel!
    
    @IBOutlet weak var profileEmailTextField: FloatLabelTextField!
    @IBOutlet weak var profileFirstNameTextField: FloatLabelTextField!
    @IBOutlet weak var profileLastNameTextField: FloatLabelTextField!
    @IBOutlet weak var profileDOBTextField: FloatLabelTextField!
    @IBOutlet weak var profileGenderTextField: FloatLabelTextField!
    @IBOutlet weak var profileAddressTextField: FloatLabelTextField!
    @IBOutlet weak var profileStateTextField: FloatLabelTextField!
    @IBOutlet weak var profileZipCodeTextField: FloatLabelTextField!
    
    // MARK: -
    /////////////////////////////////////////////////
    
    @IBOutlet weak var header_View: UIView!
    var scheduleAppointmentViewController:ScheduleAppointmentViewController!
    
    var delegate:ConversationDetailViewControllerProtocol? = nil
    
    var tableViewDataSource:MessageTableViewDataSource? = nil
    
    var selectedConversation:Conversation! = nil
    
    var isShowActivityIndicator:Bool = false
    
    let imagePicker = UIImagePickerController()
    
    /////////////////////////////////////////////////
    // MARK: - Profile View Methods
    
    
    @IBAction func profileBackButtonTapped(_ sender: Any) {
        
        self.profileV.removeFromSuperview()
        
        self.profileHeadingLabel.text = ""
        self.profileUsernameLabel.text = ""

        self.profileEmailTextField.text = ""
        self.profileFirstNameTextField.text = ""
        self.profileLastNameTextField.text = ""
        self.profileDOBTextField.text = ""
        self.profileGenderTextField.text = ""
        self.profileAddressTextField.text = ""
        self.profileStateTextField.text = ""
        self.profileZipCodeTextField.text = ""
    }
    
    
    @IBAction func profileDoneButton_Tapped(_ sender: Any) {
        
        self.profileEmailTextField.resignFirstResponder()
        self.profileFirstNameTextField.resignFirstResponder()
        self.profileLastNameTextField.resignFirstResponder()
        self.profileDOBTextField.resignFirstResponder()
        self.profileGenderTextField.resignFirstResponder()
        self.profileAddressTextField.resignFirstResponder()
        self.profileStateTextField.resignFirstResponder()
        self.profileZipCodeTextField.resignFirstResponder()
        
        ProcessingIndicator.show()
        
        var paramsDic = Dictionary<String, Any>()
        paramsDic["firstName"]   = self.profileFirstNameTextField.text
        paramsDic["lastName"]    = self.profileLastNameTextField.text
        paramsDic["birthDate"]   = self.profileDOBTextField.text
        paramsDic["gender"]      = self.profileGenderTextField.text
        paramsDic["email"]       = self.profileEmailTextField.text
        paramsDic["address"]     = self.profileAddressTextField.text
        paramsDic["state"]       = self.profileStateTextField.text
        paramsDic["zipCode"]     = self.profileZipCodeTextField.text

        paramsDic["contactID"]   = String((self.selectedConversation.receiver?.contactId)!)

        User.updateContact(params:paramsDic , completionBlockSuccess: { (status: Bool) -> (Void) in
            DispatchQueue.global(qos: .background).async
                {
                    DispatchQueue.main.async
                        {
                            if status == true {
                                
                                ProcessingIndicator.hide()
                                let alert = UIAlertController(title: "Success", message: "Contact updated sucessfully.", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))

                                self.present(alert, animated: true, completion: nil)
                            }
                            else
                            {
                                ProcessingIndicator.hide()
                                let alert = UIAlertController(title: "Error", message: "Some error occured, please try again later.", preferredStyle: UIAlertControllerStyle.alert)
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
    // MARK: -
    /////////////////////////////////////////////////

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ConversationDetailViewController.messageNotificationRecieved), name: MessageNotificationName, object: nil)
        
        
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.estimatedRowHeight = 105
        
        ////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////
        if UIDevice.current.userInterfaceIdiom == .pad {
            header_View.backgroundColor = GrayHeaderColor
        } else {
            header_View.backgroundColor = AppThemeColor
        }
        profileNavView.backgroundColor = AppThemeColor
        cross_Button.backgroundColor = AppThemeColor
        delete_Button.backgroundColor = AppThemeColor
        Optout_Button.backgroundColor = AppThemeColor
        schedule_Button.backgroundColor = AppThemeColor
        ////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////
        
        sendButton.setImage(UIImage(named:"SendMessageIcon2")?.withRenderingMode(.alwaysTemplate), for: UIControlState.normal)
        sendButton.backgroundColor = AppThemeColor
        sendButton.tintColor = UIColor.white
        sendButton.layer.borderColor =  UIColor.white.cgColor
        
        
        /*
        switch environment {
        case .texting_Line:
            if UIDevice.current.userInterfaceIdiom == .pad {
                header_View.backgroundColor = GrayHeaderColor
            } else {
                header_View.backgroundColor = AppThemeColor
            }
            cross_Button.backgroundColor = AppThemeColor
            delete_Button.backgroundColor = AppThemeColor
            Optout_Button.backgroundColor = AppThemeColor
            schedule_Button.backgroundColor = AppThemeColor
            
        case .sms_Factory:
            if UIDevice.current.userInterfaceIdiom == .pad {
                header_View.backgroundColor = GrayHeaderColor
            } else {
                header_View.backgroundColor = AppThemeColor
            }
            cross_Button.backgroundColor = AppThemeColor
            delete_Button.backgroundColor = AppThemeColor
            Optout_Button.backgroundColor = AppThemeColor
            schedule_Button.backgroundColor = AppThemeColor
            
        case .fan_Connect:
            if UIDevice.current.userInterfaceIdiom == .pad {
                header_View.backgroundColor = GrayHeaderColor
            } else {
                header_View.backgroundColor = AppThemeColor
            }
            cross_Button.backgroundColor = AppThemeColor
            delete_Button.backgroundColor = AppThemeColor
            Optout_Button.backgroundColor = AppThemeColor
            schedule_Button.backgroundColor = AppThemeColor
            
        case .photo_Texting:
            if UIDevice.current.userInterfaceIdiom == .pad {
                header_View.backgroundColor = GrayHeaderColor
            } else {
                header_View.backgroundColor = AppThemeColor
            }
            cross_Button.backgroundColor = AppThemeColor
            delete_Button.backgroundColor = AppThemeColor
            Optout_Button.backgroundColor = AppThemeColor
            schedule_Button.backgroundColor = AppThemeColor
        }
 */
        
        self.inputCharacterCountLabel.text = "Characters Count 0/250"
        
        imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
//        self.sendTextField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
        self.sendTextField.delegate = self
        
        tableViewDataSource = MessageTableViewDataSource(tableview: tableView)
        
        tableView.dataSource = tableViewDataSource
        
        if self.selectedConversation != nil
        {
            _ = self.conversationSelected(conversation: self.selectedConversation)
        }
        
        //////////////////////////////////////////////////////////////////////
        self.profileEmailTextField.layer.sublayerTransform     = CATransform3DMakeTranslation(8, 0, 0)
        self.profileFirstNameTextField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
        self.profileLastNameTextField.layer.sublayerTransform  = CATransform3DMakeTranslation(8, 0, 0)
        self.profileDOBTextField.layer.sublayerTransform       = CATransform3DMakeTranslation(8, 0, 0)
        self.profileGenderTextField.layer.sublayerTransform    = CATransform3DMakeTranslation(8, 0, 0)
        self.profileAddressTextField.layer.sublayerTransform   = CATransform3DMakeTranslation(8, 0, 0)
        self.profileStateTextField.layer.sublayerTransform     = CATransform3DMakeTranslation(8, 0, 0)
        self.profileZipCodeTextField.layer.sublayerTransform   = CATransform3DMakeTranslation(8, 0, 0)
        
        self.profileEmailTextField.isEnabled     = true
        self.profileFirstNameTextField.isEnabled = true
        self.profileLastNameTextField.isEnabled  = true
        self.profileDOBTextField.isEnabled       = true
        self.profileGenderTextField.isEnabled    = true
        self.profileAddressTextField.isEnabled   = true
        self.profileStateTextField.isEnabled     = true
        self.profileZipCodeTextField.isEnabled   = true
        //////////////////////////////////////////////////////////////////////

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: MessageNotificationName, object: nil)
        
    }
    
    @objc func messageNotificationRecieved()
    {
        if self.selectedConversation != nil
        {
            ProcessingIndicator.show()
            self.callAdhocMessagesWebService()
        }
    }
    
    
    func callAdhocMessagesWebService () {
        
        User.getMessageForConversation(self.selectedConversation, completionBlockSuccess: {(messages:Array<Message>?) -> (Void) in
            
            User.setReadConversation(conversation: self.selectedConversation, completionBlockSuccess: { (status: Bool) -> (Void) in
                
                DispatchQueue.global(qos:.background).async
                    {
                        DispatchQueue.main.async
                            {
                                ProcessingIndicator.hide()
                                
                                if self.selectedConversation.unreadMessages == true
                                {
                                    self.selectedConversation.unreadMessages = false
                                    
                                    if let delegate = self.delegate
                                    {
                                        delegate.updateConversationList()
                                    }
                                    
                                }
                                
                                _ = self.conversationSelected(conversation: self.selectedConversation)
                        }
                }
                
            }, andFailureBlock: { (error:Error?) -> (Void) in
                
                DispatchQueue.global(qos:.background).sync
                    {
                        DispatchQueue.main.sync
                            {
                                ProcessingIndicator.hide()
                                
                                if self.selectedConversation.unreadMessages == true
                                {
                                    self.selectedConversation.unreadMessages = false
                                    
                                    if let delegate = self.delegate
                                    {
                                        delegate.updateConversationList()
                                    }
                                    
                                }
                                
                                if self.selectedConversation != nil
                                {
                                    _ = self.conversationSelected(conversation: self.selectedConversation)
                                }                            }
                }
            })
            
        }) {(error:Error?) -> (Void) in
            
            DispatchQueue.global(qos:.background).sync
                {
                    DispatchQueue.main.sync
                        {
                            ProcessingIndicator.hide()
                    }
            }
        }
    }
    
    // MARK: - Button Tapped Methods

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
        
        if (self.selectedConversation == nil)
        {
            let alert = UIAlertController(title: "Warning", message: "Please select conversation first.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            self.closeView.removeFromSuperview()
            self.scheduleAppointmentViewController = UIStoryboard(name: "ScheduleAppointment", bundle: nil).instantiateViewController(withIdentifier: "ScheduleAppointmentViewController") as? ScheduleAppointmentViewController
            
            
            if self.selectedConversation.receiver?.firstName?.isEmpty == false && self.selectedConversation.receiver?.lastName?.isEmpty == false
            {
                self.scheduleAppointmentViewController.headerTitleString = (self.selectedConversation.receiver?.firstName)! + " " + (self.selectedConversation.receiver?.lastName)!
            }
            else
            {
                self.scheduleAppointmentViewController.headerTitleString = (self.selectedConversation.receiver?.phoneNumber)!
            }
            self.scheduleAppointmentViewController.selectedConversation = self.selectedConversation
            self.view.addSubview(self.scheduleAppointmentViewController.view)
            self.scheduleAppointmentViewController.view.frame = self.view.bounds
        }
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
            self.closeView.removeFromSuperview()

            
            if (self.selectedConversation.receiver?.firstName?.isEmpty == false &&
                self.selectedConversation.receiver?.lastName?.isEmpty == false)
            {
                var headingStr = (self.selectedConversation.receiver?.firstName)! + " " + (self.selectedConversation.receiver?.lastName)!
                headingStr = headingStr.uppercased()
                profileHeadingLabel.text = headingStr
            }
            else {
                profileHeadingLabel.text = ""

            }
            

            
            self.profileUsernameLabel.text = "Phone Number " + (self.selectedConversation.receiver?.phoneNumber)!
            
            self.profileEmailTextField.text = self.selectedConversation.receiver?.email
            self.profileFirstNameTextField.text = self.selectedConversation.receiver?.firstName
            self.profileLastNameTextField.text = self.selectedConversation.receiver?.lastName
     
//            if (self.selectedConversation.receiver?.birthDate = nil)
//            {
//                //-----------------------------------------------------------//
//                //-----------------------------------------------------------//
//                let dateFormatter =  DateFormatter()
//                dateFormatter.timeZone = TimeZone.current
//                dateFormatter.dateFormat = DISPLAY_FORMATE_STRING
//                let outStr = dateFormatter.string(from: (self.selectedConversation.receiver?.birthDate)!)
//                //-----------------------------------------------------------//
//                //-----------------------------------------------------------//
//                profileDOBTextField.text = outStr//self.selectedConversation.receiver?.birthDate
//
//            }
//            else {
//                profileHeadingLabel.text = ""
//
//            }
            
            self.profileDOBTextField.text = ""//self.selectedConversation.receiver?.birthDate

            self.profileGenderTextField.text = self.selectedConversation.receiver?.gender
            self.profileAddressTextField.text = self.selectedConversation.receiver?.address
            self.profileStateTextField.text = self.selectedConversation.receiver?.state
            self.profileZipCodeTextField.text = self.selectedConversation.receiver?.zipCode
            
            
            self.profileV.frame = self.view.bounds
            
            self.view.addSubview(self.profileV)
            
//
//            let alert = UIAlertController(title: "Message", message: "Opt Out functionality is coming soon.", preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//            return
            
            /*
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
             */
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
                                
                                if error != nil{
                                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                                    
                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                                    
                                    self.present(alert, animated: true, completion: nil)
                                    
                                } else {
                                    
                                    if let delegate = self.delegate
                                    {
                                        delegate.conversationRemoved()
                                    }
                                    self.navigationController?.popViewController(animated: true)
                                }
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

    // MARK: -

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
                if self.selectedConversation.receiver?.firstName?.isEmpty == false && self.selectedConversation.receiver?.lastName?.isEmpty == false
                {
                    self.messageFromLabel.text = ((self.selectedConversation.receiver?.firstName)! + " " + (self.selectedConversation.receiver?.lastName)!)
                    
                    self.messageNumberLabel.text = self.selectedConversation.receiver?.phoneNumber
                }
                else {
                    self.messageFromLabel.text = self.selectedConversation.receiver?.phoneNumber
                    self.messageNumberLabel.text = ""
                }
            }
            else {
                // If Device is iPhone/iPod
                if self.selectedConversation.receiver?.firstName?.isEmpty == false && self.selectedConversation.receiver?.lastName?.isEmpty == false
                {
                    self.messageFromLabel.text = ((self.selectedConversation.receiver?.firstName)! + " " + (self.selectedConversation.receiver?.lastName)!)
                    
                    self.messageNumberLabel.text = self.selectedConversation.receiver?.phoneNumber
                }
                else {
                    self.messageFromLabel.text = self.selectedConversation.receiver?.phoneNumber
                    self.messageNumberLabel.text = ""
                }
            }
            self.shortCodeLabel.text = ""
        }
        else
        {
            self.messageFromLabel.text =  ""
            self.messageNumberLabel.text = ""
            self.shortCodeLabel.text = ""
        }
        
        self.sendTextField.text = ""
        
        _ = self.tableViewDataSource?.loadConversation(conversation_: self.selectedConversation)
        //amir1122
        return true
    }
    
    func encode(_ s: String) -> String {
        let data = s.data(using: .nonLossyASCII, allowLossyConversion: true)!
        return String(data: data, encoding: .utf8)!
    }
    
    func sendMessageToConversation(conversation: Conversation, message: String, imageType: String, imageString: String) -> Bool {
        
        var paramsDic = Dictionary<String, Any>()
        
        // message = message.replaceEmojiWithHexa()
        //message = message.addingUnicodeEntities
        
        paramsDic["message"] = message.replaceApostropheFromString(str: message) //self.encode(message)  //.replaceEmojiWithHexa()
        paramsDic["attachment"] = imageString
        paramsDic["attachmentFileSuffix"] = imageType
        
        User.sendUserMessage(conversation: conversation, paramsJson: paramsDic, completionBlockSuccess: { (sendMessaage:Message) -> (Void) in
            
            DispatchQueue.global(qos:.background).async
                {
                    DispatchQueue.main.async
                        {
                            ProcessingIndicator.hide()
                            
                            self.sendTextField.text = ""
                            self.inputCharacterCountLabel.text = "Characters Count 0/250"
                            
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
        
        //        if str.count > sendMessageMaxLength {
        //            return false
        //        }
        
        let reminingCount = sendMessageMaxLength - str.count
        
        if reminingCount >= 0 {
            self.inputCharacterCountLabel.text = "Characters Count " + String(str.count) + "/250"
        }
        
        if str.count > sendMessageMaxLength {
            return false
        }
        
        return true
    }
    
}
