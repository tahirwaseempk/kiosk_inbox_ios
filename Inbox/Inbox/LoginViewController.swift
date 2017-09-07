//
//  LoginViewController.swift
//  Inbox
//
//  Created by Amir Akram on 21/06/2017.
//  Copyright © 2017 Amir Akram. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController
{
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var rememberMeButton: UIButton!
    @IBOutlet weak var udidTextField: UITextField!
    @IBOutlet weak var serialTextField: UITextField!

    var isAutoLogin:Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let deviceID = UIDevice.current.identifierForVendor!.uuidString
        
        self.udidTextField.text = deviceID //"323434234"
        
        self.serialTextField.text = "test-1234"
        
        self.udidTextField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
        
        self.serialTextField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
        
        self.udidTextField.isEnabled = false

        self.rememberMeButton.setImage(UIImage(named: "check-box"), for: .selected)
        self.rememberMeButton.setImage(UIImage(named: "check-box-outline"), for: .normal)
        

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
        let tickBox = Checkbox(frame: CGRect(x: 351, y: 242, width: 25, height: 25))
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
        view.addSubview(tickBox)
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
            self.rememberMeButton.isSelected = true
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
    
    func login() {
        
        if (self.serialTextField.text?.isEmpty)!
        {
            let alert = UIAlertController(title:"Warning",message:"Please enter serial!",preferredStyle:UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title:"OK",style:UIAlertActionStyle.default,handler:nil))
            
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        ProcessingIndicator.show()
        
        User.loginWithUser(serial:self.serialTextField.text!,uuid:self.udidTextField.text!,isRemember:isAutoLogin, completionBlockSuccess:{(user:User?) -> (Void) in
            
            DispatchQueue.global(qos: .background).async
                {
                    DispatchQueue.main.async
                        {
                            
                            ProcessingIndicator.hide()
                            
                            let inboxStoryboard = UIStoryboard(name:"Inbox", bundle: nil)
                            
                            let inboxViewController: InboxViewController = inboxStoryboard.instantiateViewController(withIdentifier: "InboxViewController")as! InboxViewController
                            
                            // inboxViewController.userNameLabel.text = self.serialTextField.text
                            
                            self.navigationController?.pushViewController(inboxViewController, animated: true)
                    }
            }
            
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
}
