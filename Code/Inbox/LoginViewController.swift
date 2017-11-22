//
//  LoginViewController.swift
//  Inbox
//
//  Created by Amir Akram on 21/06/2017.
//  Copyright © 2017 Amir Akram. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate
{
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var rememberMeButton: UIButton!
    @IBOutlet weak var udidTextField: UITextField!
    @IBOutlet weak var serialTextField: UITextField!
    @IBOutlet weak var fieldsView: UIView!
    
    var isAutoLogin:Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let deviceID = UIDevice.current.identifierForVendor!.uuidString
        self.udidTextField.text = deviceID //"323434234"

        self.serialTextField.text = "abfc-4f2b"
        
        self.udidTextField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
        self.serialTextField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
        
        self.udidTextField.isEnabled = false
        self.serialTextField.delegate = self
        
//        self.rememberMeButton.setImage(UIImage(named: "check-box"), for: .selected)
//        self.rememberMeButton.setImage(UIImage(named: "check-box-outline"), for: .normal)
   
     self.rememberMeButton.backgroundColor = UIColor.clear
        
        let user :User?  = User.getUserFromID(serial_: self.serialTextField.text!)
        
        if user?.isRemember == true
        {
            isAutoLogin = true
            //self.rememberMeButton.isSelected = true
            login()
        }
        else {
            //self.rememberMeButton.isSelected = false
            isAutoLogin = false
        }
        self.addCheckboxSubviews()

    }
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    func addCheckboxSubviews() {
        
        // tick
        let tickBox = Checkbox(frame: self.rememberMeButton.bounds)
        tickBox.borderColor = UIColor.black
        tickBox.checkmarkColor = UIColor.black
        tickBox.borderStyle = .square
        tickBox.checkmarkStyle = .tick
        tickBox.checkmarkSize = 0.8
        if isAutoLogin == true {
            tickBox.isChecked = true
        } else {
            tickBox.isChecked = false
        }
        tickBox.addTarget(self, action: #selector(circleBoxValueChanged(sender:)), for: .valueChanged)
        self.rememberMeButton.addSubview(tickBox)
    }
    
    // target action example
     @objc func circleBoxValueChanged(sender: Checkbox) {
        
        
        if sender.isChecked == true {
           isAutoLogin = true
        } else {
            isAutoLogin = false
        }
        
        print("circle box value change: \(sender.isChecked)")
    }
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    @IBAction func loginButton_Tapped(_ sender: Any)
    {
        self.login()
    }
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    @IBAction func rememberMeButton_Tapped(_ sender: Any)
    {
        
//        if isAutoLogin == false
//        {
//            self.rememberMeButton.isSelected = true
//            isAutoLogin = true
//        }
//        else {
//            self.rememberMeButton.isSelected = false
//            isAutoLogin = false
//        }
    }
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
}

extension LoginViewController {
    
    func login()
    {
        if (self.serialTextField.text?.isEmpty)!
        {
            let alert = UIAlertController(title:"Warning",message:"Please enter serial!",preferredStyle:UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title:"OK",style:UIAlertActionStyle.default,handler:nil))
            
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        ProcessingIndicator.show()
        
        User.loginWithUser(serial:self.serialTextField.text!,uuid:self.udidTextField.text!,isRemember:isAutoLogin, completionBlockSuccess:{(user:User?) -> (Void) in
            
            
            User.registerUserAPNS(serial: self.serialTextField.text!, uuid: self.udidTextField.text!, completionBlockSuccess: { (deviceRegistered:Bool) -> (Void) in
                
                DispatchQueue.global(qos: .background).async
                    {
                        DispatchQueue.main.async
                            {
                                //ProcessingIndicator.hide()
                                
                                let homeStoryboard = UIStoryboard(name:"Home", bundle: nil)
                                
                                let homeViewController: HomeViewController = homeStoryboard.instantiateViewController(withIdentifier: "HomeViewController")as! HomeViewController
                                
                                // inboxViewController.userNameLabel.text = self.serialTextField.text
                                
                                self.navigationController?.pushViewController(homeViewController, animated: true)
                        }
                }
                
            }, andFailureBlock: { (error:Error?) -> (Void) in
                
                DispatchQueue.global(qos: .background).async
                    {
                        DispatchQueue.main.async
                            {
                                //ProcessingIndicator.hide()
                                
                                let homeStoryboard = UIStoryboard(name:"Home", bundle: nil)
                                
                                let homeViewController: HomeViewController = homeStoryboard.instantiateViewController(withIdentifier: "HomeViewController")as! HomeViewController
                                
                                // inboxViewController.userNameLabel.text = self.serialTextField.text
                                
                                self.navigationController?.pushViewController(homeViewController, animated: true)
                        }
                }

            })

            
        }) { (error:Error?) -> (Void) in
            
            DispatchQueue.global(qos:.background).async
                {
                    DispatchQueue.main.async
                        {
                            ProcessingIndicator.hide()
                            
                            let alert = UIAlertController(title:"Error!",message:"Unable to login",preferredStyle: UIAlertControllerStyle.alert)
                            
                            alert.addAction(UIAlertAction(title:"OK",style:UIAlertActionStyle.default,handler: nil))
                            
                            self.present(alert,animated:true,completion:nil)
                    }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        udidTextField.resignFirstResponder()
        
        serialTextField.resignFirstResponder()
        
        return true;
    }
}


extension LoginViewController {
    

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if textField == serialTextField{
            
            return checkEnglishPhoneNumberFormat(string: string, str: str)
            
        } else {
            
            return true
        }
    }
    
    func checkEnglishPhoneNumberFormat(string: String?, str: String?) -> Bool{
        
        if string == ""{ //BackSpace
            
            return true
            
        }else if str!.characters.count == 5 {
            
//            if str!.characters.count == 1{
            
                serialTextField.text = serialTextField.text! + "-"
//            }
            
        }else if str!.characters.count > 9{
            
            return false

        }
        
        return true
    }
}

