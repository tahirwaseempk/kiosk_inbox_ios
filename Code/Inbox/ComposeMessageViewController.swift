//
//  ComposeMessage.swift
//  Inbox
//
//  Created by Amir Akram on 24/08/2017.
//  Copyright © 2017 Amir Akram. All rights reserved.
//

import Foundation

import ContactsUI

class ComposeMessageViewController: UIViewController {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var messageTextView: UITextView!
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var inputCharacterCountLabel: UILabel!
    
    @IBOutlet weak var header_label: UILabel!
    
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!

    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var mobileNumberView: UIView!
    
    var delegate : ComposeMessageProtocol? = nil
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        switch environment {

        case .texting_Line:
        headerView.backgroundColor = AppThemeColor
        mobileNumberView.backgroundColor = AppThemeColor

        sendButton.setImage(UIImage(named: "new_Send")?.withRenderingMode(.alwaysTemplate), for: UIControlState.normal)
        sendButton.tintColor = AppThemeColor
        sendButton.layer.borderColor = AppThemeColor.cgColor

        case .sms_Factory:
        headerView.backgroundColor = AppThemeColor
        mobileNumberView.backgroundColor = AppThemeColor
         
        sendButton.setImage(UIImage(named: "new_Send")?.withRenderingMode(.alwaysTemplate), for: UIControlState.normal)
        sendButton.tintColor = AppThemeColor
        sendButton.layer.borderColor = AppThemeColor.cgColor
            
        case .fan_Connect:
        headerView.backgroundColor = AppThemeColor
        mobileNumberView.backgroundColor = AppThemeColor

        sendButton.setImage(UIImage(named: "new_Send")?.withRenderingMode(.alwaysTemplate), for: UIControlState.normal)
        sendButton.tintColor = AppThemeColor
        sendButton.layer.borderColor = AppThemeColor.cgColor
            
        case .photo_Texting:
        headerView.backgroundColor = AppThemeColor
        mobileNumberView.backgroundColor = AppThemeColor

        sendButton.setImage(UIImage(named: "new_Send")?.withRenderingMode(.alwaysTemplate), for: UIControlState.normal)
        sendButton.tintColor = AppThemeColor
        sendButton.layer.borderColor = AppThemeColor.cgColor
    }
    
        mobileTextField.text = ""
        mobileTextField.delegate = self
        mobileTextField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)

        
        backView.layer.cornerRadius = 5;
        self.view.addSubview(backView)
        
        messageTextView.delegate = self
        messageTextView.text = "Enter your message"
        messageTextView.textColor = UIColor.lightGray
        messageTextView.layer.sublayerTransform = CATransform3DMakeTranslation(4, 0, 0)
        messageTextView.textContainer.lineBreakMode = NSLineBreakMode.byWordWrapping
        messageTextView.isScrollEnabled = false
        
        self.inputCharacterCountLabel.text = "Characters Count 0/250"
    }
    
    @IBAction func cancel_Tapped(_ sender: Any) {
        
        self.hideComposeMessageView()
    }
    
    @IBAction func sendMessage_Tapped(_ sender: Any) {
        
        //        _ = self.testMethod(mobile: "", message: "");
        //        return;
        
        self.view .endEditing(true)
        
        if (mobileTextField.text?.isEmpty)! {
            
            let alert = UIAlertController(title: "Compose Message", message: "Please enter mobile number.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if ((messageTextView.text == "Enter your message") ||
            (messageTextView.text.count == 0)) {
            
            let alert = UIAlertController(title: "Compose Message", message: "Please enter message.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            _ = self.sendMessageToConversation(mobile: self.mobileTextField.text!, message: self.messageTextView.text!)
        }
    }
    
    @IBAction func dismissButton_Tapped(_ sender: Any) {
        
    }
    
    func hideComposeMessageView() {
        
        self.view.removeFromSuperview()
        
    }
    
    @IBAction func contactsButton_Tapped(_ sender: Any) {
        
        let cnPicker = CNContactPickerViewController()
        cnPicker.delegate = self
        cnPicker.displayedPropertyKeys = [CNContactPhoneNumbersKey]
        self.present(cnPicker, animated: true, completion: nil)
    }
}

extension ComposeMessageViewController : CNContactPickerDelegate {
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {
        
        let contact = contactProperty.contact
        let identifierStr = contactProperty.identifier
        
        for phoneNumber in contact.phoneNumbers {
            if phoneNumber.identifier == identifierStr {
                let myString = phoneNumber.value.stringValue;
                mobileTextField.text = self.format(phoneNumber: myString)
            }
        }
    }
    
    func format(phoneNumber sourcePhoneNumber: String) -> String? {
        // Remove any character that is not a number
        let numbersOnly = sourcePhoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let length = numbersOnly.count
        let hasLeadingOne = numbersOnly.hasPrefix("1")
        
        // Check for supported phone number length
        guard length == 7 || length == 10 || (length == 11 && hasLeadingOne) else {
            return nil
        }
        
        let hasAreaCode = (length >= 10)
        var sourceIndex = 0
        
        // Leading 1
        var leadingOne = ""
        if hasLeadingOne {
            leadingOne = "1 "
            sourceIndex += 1
        }
        
        // Area code
        var areaCode = ""
        if hasAreaCode {
            let areaCodeLength = 3
            guard let areaCodeSubstring = numbersOnly.substring(start: sourceIndex, offsetBy: areaCodeLength) else {
                return nil
            }
            areaCode = String(format: "(%@) ", areaCodeSubstring)
            sourceIndex += areaCodeLength
        }
        
        // Prefix, 3 characters
        let prefixLength = 3
        guard let prefix = numbersOnly.substring(start: sourceIndex, offsetBy: prefixLength) else {
            return nil
        }
        sourceIndex += prefixLength
        
        // Suffix, 4 characters
        let suffixLength = 4
        guard let suffix = numbersOnly.substring(start: sourceIndex, offsetBy: suffixLength) else {
            return nil
        }
        
        return leadingOne + areaCode + prefix + "-" + suffix
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        print("Cancel Contact Picker")
    }
}

extension String {
    /// This method makes it easier extract a substring by character index where a character is viewed as a human-readable character (grapheme cluster).
    internal func substring(start: Int, offsetBy: Int) -> String? {
        guard let substringStartIndex = self.index(startIndex, offsetBy: start, limitedBy: endIndex) else {
            return nil
        }
        
        guard let substringEndIndex = self.index(startIndex, offsetBy: start + offsetBy, limitedBy: endIndex) else {
            return nil
        }
        
        return String(self[substringStartIndex ..< substringEndIndex])
    }
}

// MARK: - TextView Delegates
extension ComposeMessageViewController : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        self.textViewHeightConstraint.constant = textView.contentSize.height
        updateHeight()
    }
    
    func updateHeight() {
         var newFrame = messageTextView.frame
         
         let fixedWidth = messageTextView.frame.size.width
         let newSize = messageTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
         
         newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
         self.messageTextView.frame = newFrame
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
        let str = (textView.text! as NSString).replacingCharacters(in: range, with: text)
        
        let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
        let filtered = text.components(separatedBy: cs).joined(separator: "")
        let isAllowed = (text == filtered)
        
        if isAllowed == false {
            return false
        }
        
        let reminingCount = sendMessageMaxLength - str.count
        
        if reminingCount >= 0 {
            self.inputCharacterCountLabel.text = "Characters Count " + String(str.count) + "/250"
        }
        
//        var frame = self.messageTextView.frame
//        frame.size.height = self.messageTextView.contentSize.height
        //       self.textViewHeightConstraint = frame.size.height

//        if str.count == 25 {
//        self.textViewHeightConstraint.constant = self.messageTextView.contentSize.height + 35
//        }
//        self.messageTextView.setNeedsLayout()
        
        if str.count > sendMessageMaxLength {
            return false
        }
        
        return true
    }
    
}

// MARK: - Text Field Delegates

extension ComposeMessageViewController : UITextFieldDelegate {
    
    //    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    //
    //        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
    //        let compSepByCharInSet = string.components(separatedBy: aSet)
    //        let numberFiltered = compSepByCharInSet.joined(separator: "")
    //        return string == numberFiltered
    //    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        
        if textField == mobileTextField{
            
            return checkEnglishPhoneNumberFormat(string: string, str: str)
            
        } else {
            
            
            return true
        }
    }
    
    
    func checkEnglishPhoneNumberFormat(string: String?, str: String?) -> Bool{
        
        if string == ""{ //BackSpace
            
            return true
            
        }else if str!.count < 3{
            
            if str!.count == 1{
                
                mobileTextField.text = "("
            }
            
        }else if str!.count == 5{
            
            mobileTextField.text = mobileTextField.text! + ") "
            
        }else if str!.count == 10{
            
            mobileTextField.text = mobileTextField.text! + "-"
            
        }else if str!.count > 14{
            
            //return false
        }
        
        return true
    }
}

extension ComposeMessageViewController {
    
    func sendMessageToConversation(mobile: String, message: String) -> Bool {
        
        ProcessingIndicator.show()
        
       let mobileString  = removeSpecialCharsFromString(mobile)
        
        User.composeNewMessage(mobile: mobileString, message: message, contactId: 0, completionBlockSuccess: { (status: Bool) -> (Void) in
            DispatchQueue.global(qos: .background).async
                {
                    DispatchQueue.main.async
                        {
                            if status == true {
                                
                                self.hideComposeMessageView()
                                
                                self.mobileTextField.text = ""
                                self.messageTextView.text = ""
                                
                                if let delegate = self.delegate
                                {
                                    delegate.newMessageAdded()
                                }
                            }
                            else
                            {
                                ProcessingIndicator.hide()
                                let alert = UIAlertController(title: "Error", message: "Some error occured at server end. Please try again later.", preferredStyle: UIAlertControllerStyle.alert)
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
        return true
    }
}

