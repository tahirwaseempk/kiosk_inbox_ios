//
//  VerifyCodeViewController.swift
//  Inbox
//
//  Created by Amir Akram on 13/10/2018.
//  Copyright © 2018 Amir Akram. All rights reserved.
//

import UIKit

class VerifyCodeViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var numberTextField: FloatLabelTextField!
    
    @IBOutlet weak var header_Label: UILabel!
    @IBOutlet weak var heading2_Label: UILabel!
    @IBOutlet weak var done_Button: UIButton!
    @IBOutlet weak var back_Button: UIButton!
    
    @IBOutlet var codeView: UIView!
    @IBOutlet weak var codeTextField: UITextField!
    
    var randomString : String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        
        self.numberTextField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
        self.numberTextField.delegate = self
        
//        self.codeTextField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
        self.codeTextField.delegate = self
       
        self.numberTextField.text = ""
        self.codeTextField.text   = ""
        
        

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        NotificationCenter.default.removeObserver(self, name: .postNotifi, object: nil)
    }
    
    @IBAction func doneButton_Tapped(_ sender: Any) {
        
        self.numberTextField.resignFirstResponder()

        if (self.numberTextField.text?.isEmpty)!
        {
            let alert = UIAlertController(title:"Warning",message:"Please enter number.",preferredStyle:UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title:"OK",style:UIAlertActionStyle.default,handler:nil))
            
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        randomString = ""
        for _ in 1...6 {
            let numberR = Int.random(in: 0 ..< 9)
            randomString = randomString + String(numberR)
        }
        
        ProcessingIndicator.show()
        
        var paramsDic = Dictionary<String, Any>()
        
        paramsDic["mobile"] = self.numberTextField.text
        paramsDic["message"] =  "Here is the code for the mobile verification:" + randomString
        
        User.verifyNumber(params:paramsDic , completionBlockSuccess: { (status: Bool) -> (Void) in
            DispatchQueue.global(qos: .background).async
                {
                    DispatchQueue.main.async
                        {
                            if status == true {
                                
                                ProcessingIndicator.hide()
                                
                                self.view.addSubview(self.codeView)
                                self.codeView.frame = self.view.bounds
                                
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
                            self.numberTextField.text = ""
                            let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                    }
            }
        })
        
    }
    
    @IBAction func backButton_Tapped(_ sender: Any) {
        
        self.view.removeFromSuperview()
    }
    
    @IBAction func innerDoneButton_Tapped(_ sender: Any) {
        self.codeTextField.resignFirstResponder()

    }
    
    @IBAction func innerBackButton_Tapped(_ sender: Any) {
        
        self.codeTextField.resignFirstResponder()
        self.codeView.removeFromSuperview()
    }
    
    @IBAction func resendButton_Tapped(_ sender: Any) {
        
    }
    
    func checkVerificationCode(inputCode: String) {
        
        print(randomString)
        if inputCode == randomString
        {
            ProcessingIndicator.show()
            
            var paramsDic = Dictionary<String, Any>()
            paramsDic["mobile"] = self.numberTextField.text
           let user = User.getLoginedUser()
            
            paramsDic["firstName"]   = user?.firstName
            paramsDic["lastName"]    = user?.lastName
            paramsDic["email"]       = user?.email
            paramsDic["companyName"] = user?.companyName
            paramsDic["address"]     = user?.address
            paramsDic["city"]        = user?.city
            paramsDic["state"]       = user?.state
            paramsDic["zipCode"]     = user?.zipCode
            paramsDic["country"]     = user?.country
            
            User.updateUser(params:paramsDic , completionBlockSuccess: { (status: Bool) -> (Void) in
                DispatchQueue.global(qos: .background).async
                    {
                        DispatchQueue.main.async
                            {
                                if status == true {
                                    
                                    ProcessingIndicator.hide()
                                    let alert = UIAlertController(title: "Success", message:"Thank you, your mobile number is now confimred.", preferredStyle: UIAlertControllerStyle.alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
                                        self.view.removeFromSuperview()
                                    }))
                                    
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
            
        } else {
            self.codeTextField.text = ""
            let alert = UIAlertController(title: "Error", message:"You have entered wrong code, please enter again.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension VerifyCodeViewController {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField == self.numberTextField) {
            let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_DIGITS).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            let isAllowed = (string == filtered)
            
            if isAllowed == false {
                return false
            }
            
            if str.count > PHONENUMBER_MAX_LENGTH {
                return false
            }
        } else if (textField == self.codeTextField) {
           
            let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_DIGITS).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            let isAllowed = (string == filtered)
            
            if isAllowed == false {
                return false
            }
            
            //[NotificationCenter .default.addObserver(self, selector: #selector(textHasChanged), name: NSNotification.Name.UITextFieldTextDidChange, object: self.codeTextField)]
            
            if str.count > CODE_MAX_LENGTH {
                self.codeTextField.resignFirstResponder()
                return false
            }
            
//            if str.count == CODE_MAX_LENGTH {
//                return true
//            }
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.numberTextField.resignFirstResponder()
        self.codeTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)  {
        
        if textField == self.codeTextField {
            if textField.text?.count == 6 {
              _ = self.checkVerificationCode(inputCode: textField.text!)
            } else {
                let alert = UIAlertController(title: "Error", message:"You have entered wrong code, please enter again.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
//extension Notification.Name {
//    static let postNotifi = Notification.Name(
//        rawValue: "postNotifi")
//}
