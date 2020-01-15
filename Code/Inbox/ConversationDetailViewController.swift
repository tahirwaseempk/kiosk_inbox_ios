import UIKit
import SwiftyPickerPopover

class ConversationDetailViewController: UIViewController, ConversationListingTableCellProtocol
{
    @IBOutlet weak var sendTextField: UITextView!
    @IBOutlet weak var messageFromLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var scrollButton: UIButton!

    @IBOutlet weak var inputCharacterCountLabel: UILabel!
    
    @IBOutlet weak var chawalView: UIView!
    
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var header_View: UIView!
    var scheduleAppointmentViewController:ScheduleAppointmentViewController!
    
    var delegate:ConversationDetailViewControllerProtocol? = nil
    
    var tableViewDataSource:MessageTableViewDataSource? = nil
    
    var selectedConversation:Conversation! = nil
    
    
    let imagePicker = UIImagePickerController()
    
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: -
    // MARK: Main View Controllers Methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(ConversationDetailViewController.messageNotificationRecieved), name: MessageNotificationName, object: nil)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 105
        tableView.clipsToBounds = false
        
        header_View.blurView.setup(style: UIBlurEffectStyle.extraLight, alpha: 0.9).enable()

        
        
        sendTextField.inputAccessoryView = UIView()
        ////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////
        if UIDevice.current.userInterfaceIdiom == .pad {
            //            header_View.backgroundColor = GrayHeaderColor
        } else {
            //            header_View.backgroundColor = AppThemeColor
        }
        //profileNavView.backgroundColor = AppThemeColor
        //  cross_Button.backgroundColor = AppThemeColor
        //  delete_Button.backgroundColor = AppThemeColor
        // Optout_Button.backgroundColor = AppThemeColor
        // schedule_Button.backgroundColor = AppThemeColor
        ////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////
        
        //sendButton.setImage(UIImage(named:"send-message")?.withRenderingMode(.alwaysTemplate), for: UIControlState.normal)
        //sendButton.backgroundColor = AppThemeColor
        //sendButton.tintColor = UIColor.white
        //sendButton.layer.borderColor =  UIColor.white.cgColor
        
        
        
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
        
        self.inputCharacterCountLabel.text = "Character Count 0/250"
        
        imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
        self.sendTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        self.sendTextField.delegate = self
        self.chawalView.layer.cornerRadius =  self.chawalView.bounds.height/2
        
        self.sendTextField.text = "Please enter message here"
        self.sendTextField.textColor = UIColor.lightGray
        ////////////////////////////////////////////////////////////////////////////////////////
        //refreshControl.addTarget(self, action: #selector(refreshListingTable), for: .valueChanged)
        //tableView.refreshControl = refreshControl
        ////////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////////
        // header_View.backgroundColor = AppThemeColor
        /*
         switch environment {
         case .texting_Line:
         header_View.backgroundColor = AppThemeColor
         case .sms_Factory:
         header_View.backgroundColor = AppThemeColor
         case .fan_Connect:
         header_View.backgroundColor = AppThemeColor
         case .photo_Texting:
         header_View.backgroundColor = AppThemeColor
         }
         */
        
        tableViewDataSource = MessageTableViewDataSource(tableview: tableView, delegate_:self)
        
        if self.selectedConversation != nil
        {
            _ = self.conversationSelected(conversation: self.selectedConversation)
        }
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
            self.callAdhocMessagesWebService("")
        }
    }
    
    @objc func refreshListingTable(refreshControl: UIRefreshControl) {
        
        self.callAdhocMessagesWebService("")
    }
    
    // MARK: -
    // MARK: Button Tapped Actions
    
    @IBAction func backButton_Tapped(_ sender: Any) {
        
        self.view.endEditing(true)

        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func scheduleAppointment_Tapped(_ sender: Any) {
        
        self.view.endEditing(true)

        if (self.selectedConversation == nil)
        {
            let alert = UIAlertController(title: "Warning", message: "Please select conversation first.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
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
    
    @IBAction func profileButton_Tapped(_ sender: Any) {
        
        self.view.endEditing(true)

        if (self.selectedConversation == nil)
        {
            let alert = UIAlertController(title: "Warning", message: "Please select conversation first.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            self.loadProfileView()
            return
        }
    }
    
    @IBAction func sendMessage_Tapped(_ sender: Any) {

        self.view.endEditing(true)

        if (self.selectedConversation == nil)
        {
            let alert = UIAlertController(title: "Send Message", message: "Please select conversation first.", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            if (self.sendTextField.text?.isEmpty == true ||
                self.sendTextField.text == "Please enter message here" ||
                self.sendTextField.text.count == 0 ||
                self.sendTextField.textColor == UIColor.lightGray)
            {
                let alert = UIAlertController(title: "Send Message", message: "Please enter message.", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
               
            } else
            {
                ProcessingIndicator.show()
                               
                _ = self.sendMessageToConversation(conversation: self.selectedConversation, message: self.sendTextField.text!, imageType: "", imageString: "")
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
                    self.messageFromLabel.text = (self.selectedConversation.receiver?.firstName)! + " " + (self.selectedConversation.receiver?.lastName)!
                    
                    // self.messageNumberLabel.text = self.selectedConversation.receiver?.phoneNumber
                }
                else {
                    self.messageFromLabel.text = self.selectedConversation.receiver?.phoneNumber
                    // self.messageNumberLabel.text = ""
                }
            }
            else {
                // If Device is iPhone/iPod
                if self.selectedConversation.receiver?.firstName?.isEmpty == false && self.selectedConversation.receiver?.lastName?.isEmpty == false
                {
                    self.messageFromLabel.text = (self.selectedConversation.receiver?.firstName)! + " " + (self.selectedConversation.receiver?.lastName)!
                    
                    // self.messageNumberLabel.text = self.selectedConversation.receiver?.phoneNumber
                }
                else {
                    self.messageFromLabel.text = self.selectedConversation.receiver?.phoneNumber
                    //  self.messageNumberLabel.text = ""
                }
            }
            //self.shortCodeLabel.text = ""
        }
        else
        {
            self.messageFromLabel.text =  ""
            // self.messageNumberLabel.text = ""
            // self.shortCodeLabel.text = ""
        }
        
        //self.sendTextField.text = ""
        
        _ = self.tableViewDataSource?.loadConversation(conversation_: self.selectedConversation)
        //amir1122
        return true
    }
    
    func encode(_ s: String) -> String {
        let data = s.data(using: .nonLossyASCII, allowLossyConversion: true)!
        return String(data: data, encoding: .utf8)!
    }
    
    
    func utf8DecodedString(str: String)-> String {
        let data = str.data(using: .utf8)
        if let message = String(data: data!, encoding: .nonLossyASCII){
            return message
        }
        return ""
    }
    
    func utf8EncodedString(str: String)-> String {
        let messageData = str.data(using: .nonLossyASCII)
        let text = String(data: messageData!, encoding: .utf8)
        return text!
    }
    
    func sendMessageToConversation(conversation: Conversation, message: String, imageType: String, imageString: String) -> Bool {
        
        var paramsDic = Dictionary<String, Any>()
        
        // message = message.replaceEmojiWithHexa()
        // var message2 = message.utf8 //.addingUnicodeEntities
        // text2 = text2.replacingOccurrences(of: "\\", with: "", options: NSString.CompareOptions.literal, range: nil)
        
        var tempMessage = message.replaceApposphereStartWithAllowableString()
        tempMessage = tempMessage.replaceApposphereEndWithAllowableString()
        tempMessage = tempMessage.replaceBDotsAllowableString()
        paramsDic["message"] = tempMessage.replaceFDotsAllowableString()

        
        //self.utf8EncodedString(str: message) //self.encode(message)  //.replaceEmojiWithHexa()
        paramsDic["attachment"] = imageString
        paramsDic["attachmentFileSuffix"] = imageType
        
        User.sendUserMessage(conversation: conversation, paramsJson: paramsDic, completionBlockSuccess: { (sendMessaage:Message) -> (Void) in
            
            DispatchQueue.global(qos:.background).async
                {
                    DispatchQueue.main.async
                        {
                            ProcessingIndicator.hide()
                            
                            self.clearTextField()
                            
                            _ = self.tableViewDataSource?.reloadControls()
                    }
            }
            
        }) { (error:Error?) -> (Void) in
            
            DispatchQueue.global(qos:.background).async
                {
                    DispatchQueue.main.async
                        {
                            ProcessingIndicator.hide()
                            
                            self.clearTextField()
                            
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
extension ConversationDetailViewController:UITextViewDelegate
{
    func clearTextField()
    {
        self.sendTextField.text = "Please enter message here"
        
        self.inputCharacterCountLabel.text = "Character Count 0/250"
        
        self.sendTextField.textColor = UIColor.lightGray
        
        self.updateTextViewHeight()

        self.view.endEditing(true)

    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        
        self.updateTextViewHeight()
    }
    
    func updateTextViewHeight()
    {
        let height = sendTextField.sizeThatFits(CGSize(width:sendTextField.frame.size.width, height:CGFloat.greatestFiniteMagnitude)).height
        
        if height > 100
        {
            self.sendTextField.isScrollEnabled = true
        }
        else
        {
            self.textViewHeightConstraint.constant = height
            
            self.sendTextField.layoutIfNeeded()
            
            self.sendTextField.setNeedsDisplay()
            
            self.sendTextField.isScrollEnabled = false
        }
    }
    
        
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.isEmpty {
            textView.text = "Please enter message here"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if (text == "\n") {
            textView.text = textView.text + "\n"
            return true
        }
        
        let str = (textView.text! as NSString).replacingCharacters(in: range, with: text)
        
        let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
        let filtered = text.components(separatedBy: cs).joined(separator: "")
        let isAllowed = (text == filtered)
        
        if isAllowed == false {
            return false
        }
        
        let reminingCount = sendMessageMaxLength - str.count
        
        if reminingCount >= 0 {
            self.inputCharacterCountLabel.text = "Character Count " + String(str.count) + "/250"
        }
        
        if str.count > sendMessageMaxLength {
            return false
        }
        
        return true
    }
}

extension ConversationDetailViewController:MessageTableViewDataSourceProtocol
{
    func loadMoreMessages(messageId:String, completionBlockSuccess successBlock: @escaping ((_ messages:Array<Message>) -> (Void)), andFailureBlock failureBlock: @escaping ((Error?) -> (Void)))
    {
        ProcessingIndicator.show()
        UserDefaults.standard.set("true", forKey: "SHOULD_SCROLL")
        UserDefaults.standard.synchronize()
        
        self.callAdhocMessagesWebServiceCallBackBased(messageId, completionBlockSuccess:successBlock, andFailureBlock:failureBlock)
        
    }
    
    @IBAction func scrollButtonTapped(_ sender: Any)
    {

        self.tableViewDataSource?.scrollTableViewtoBottom()
        self.scrollButton.isHidden = true
    }
    
    func updateScrollButtonVisibility()
    {
        let threshold: CGFloat = 76.0
        
        self.scrollButton.isHidden = true
        
        let contentOffset = self.tableView.contentOffset.y
        
        let maximumOffset = self.tableView.contentSize.height - self.tableView.frame.size.height;
        
        if  maximumOffset - contentOffset <= threshold
        {
            self.scrollButton.isHidden = true
        }
        else
        {
            self.scrollButton.isHidden = false
        }
    }
    
    func callAdhocMessagesWebService (_ lastMsgId: String)
    {
        self.callAdhocMessagesWebServiceCallBackBased(lastMsgId, completionBlockSuccess: { (messages:Array<Message>) -> (Void) in
            
            // No Need to handle stuff
            
        }) { (error:Error?) -> (Void) in
            
        }
    }
    
    func callAdhocMessagesWebServiceCallBackBased (_ lastMsgId: String, completionBlockSuccess successBlock: @escaping ((_ messages:Array<Message>) -> (Void)), andFailureBlock failureBlock: @escaping ((Error?) -> (Void)))
    {
        User.getMessageForConversation(conversation:self.selectedConversation, lastMessageId:lastMsgId, completionBlockSuccess: {(messages:Array<Message>?) -> (Void) in
            
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
                                
                                self.refreshControl.endRefreshing()
                                
                                successBlock(messages!)
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
                                }
                                
                                self.refreshControl.endRefreshing()
                                
                                failureBlock(error)
                        }
                }
            })
            
        }) {(error:Error?) -> (Void) in
            
            DispatchQueue.global(qos:.background).sync
                {
                    DispatchQueue.main.sync
                        {
                            self.refreshControl.endRefreshing()
                            
                            ProcessingIndicator.hide()
                            
                            failureBlock(error)
                    }
            }
        }
    }
}

extension ConversationDetailViewController:ContactDetailViewControllerDelegate
{
    func newMessageAdded() {
        
    }
    
    func loadProfileView()
    {
        if let contact = self.selectedConversation.receiver
        {
            let viewController:ContactDetailViewController = UIStoryboard(name:"Contacts", bundle: nil).instantiateViewController(withIdentifier:"ContactDetailViewController") as! ContactDetailViewController

            viewController.contact = contact
            
            viewController.delegate = self

            viewController.shouldShowComposeButton = false
            
            self.navigationController?.pushViewController(viewController, animated:true)
        }
    }
    
    func deleteContactsFromLocalArrays(contactsToRemove:Array<UserContact>)
    {
        
    }
}
