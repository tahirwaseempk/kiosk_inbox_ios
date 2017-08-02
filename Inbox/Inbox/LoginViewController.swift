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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.udidTextField.text = "323434234"
        
        self.serialTextField.text = "test-test"
        
        self.udidTextField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
        
        self.serialTextField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
        
        self.udidTextField.isEnabled = false
    }
    
    @IBAction func loginButton_Tapped(_ sender: Any)
    {
        
        if (self.serialTextField.text?.isEmpty)!
        {
            let alert = UIAlertController(title:"Warning",message:"Please enter serial!",preferredStyle:UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title:"OK",style:UIAlertActionStyle.default,handler:nil))
            
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        ProcessingIndicator.show()
        User.loginWithUser(serial:self.serialTextField.text!,uuid:self.udidTextField.text!,isRemember:false, completionBlockSuccess:{(user:User?) -> (Void) in
            
            DispatchQueue.global(qos: .background).async
                {
                    DispatchQueue.main.async
                        {
                            
                            ProcessingIndicator.hide()
                            
                            let inboxStoryboard = UIStoryboard(name:"Inbox", bundle: nil)
                            
                            let inboxViewController: InboxViewController = inboxStoryboard.instantiateViewController(withIdentifier: "InboxViewController")as! InboxViewController
                            
                            inboxViewController.conversations = user?.conversations
                            //inboxViewController.userNameLabel.text = self.serialTextField.text
                            
                            self.navigationController?.setViewControllers([inboxViewController], animated: true)
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
    
    @IBAction func rememberMeButton_Tapped(_ sender: Any)
    {
        
        (sender as! UIButton).setImage(UIImage(named: "check_box"), for: .normal)
        
    }
}
