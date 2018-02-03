//
//  ComposeMessage.swift
//  Inbox
//
//  Created by Amir Akram on 24/08/2017.
//  Copyright © 2017 Amir Akram. All rights reserved.
//

import Foundation


class ComposeMessageViewController: UIViewController {
    
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var messageTextView: UITextView!
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var inputCharacterCountLabel: UILabel!
    
    var delegate : ComposeMessageProtocol? = nil
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        mobileTextField.text = ""
        mobileTextField.delegate = self
        mobileTextField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
        mobileTextField.attributedPlaceholder = NSAttributedString(string:"Mobile Number", attributes:  [NSForegroundColorAttributeName: UIColor.lightGray])
        
        
        backView.layer.cornerRadius = 5;
        self.view.addSubview(backView)
        
        sendButton.layer.cornerRadius = 5
        sendButton.layer.borderWidth = 2
        let bordercolor = UIColor(red: 74.0/255.0, green: 144.0/255.0, blue: 236.0/255.0, alpha: 1.0)
        cancelButton.backgroundColor = UIColor.white
        sendButton.layer.borderColor = bordercolor.cgColor
        
        cancelButton.layer.cornerRadius = 5
        cancelButton.layer.borderWidth = 1
        cancelButton.backgroundColor = UIColor.white
        cancelButton.layer.borderColor = UIColor.clear.cgColor
        
        messageTextView.delegate = self
        messageTextView.text = "Enter your message"
        messageTextView.textColor = UIColor.lightGray
        messageTextView.layer.sublayerTransform = CATransform3DMakeTranslation(4, 0, 0)
    }
    
    @IBAction func cancel_Tapped(_ sender: Any) {
        
        self.hideComposeMessageView()
    }
    
    
    @IBAction func sendMessage_Tapped(_ sender: Any) {
        
        self.view .endEditing(true)
        
        if (mobileTextField.text?.isEmpty)! {
            
            let alert = UIAlertController(title: "Compose Message", message: "Please enter mobile number.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if ((messageTextView.text == "Please enter message here") ||
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
}

extension ComposeMessageViewController : UITextViewDelegate {
    
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
        
        let reminingCount = 160 - str.count
        
        if reminingCount >= 0
        {
            self.inputCharacterCountLabel.text = "Remaining Characters " + String(160-str.count)
        }

        if str.count > 160
        {
            return false
        }
        
        return true
    }
}

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
            
            return false
        }
        
        return true
    }
}

extension ComposeMessageViewController {
    
    func sendMessageToConversation(mobile: String, message: String) -> Bool {
        
        ProcessingIndicator.show()
        
        User.composeNewMessage(mobile: mobile, message: message, completionBlockSuccess: { (status: Bool) -> (Void) in
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


