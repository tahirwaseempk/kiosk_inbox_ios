//
//  LoginViewController.swift
//  Inbox
//
//  Created by tahir on 20/06/2017.
//  Copyright © 2017 Amir Akram. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var rememberMeButton: UIButton!
    @IBOutlet weak var udidTextField: UITextField!
    @IBOutlet weak var serialTextField: UITextField!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButton_Tapped(_ sender: Any) {
        
        
        WebManager.requestLogin(params:Dictionary(),messageParser: MessagesParser(), completionBlockSuccess: { (conversations:Array<ConversationDataModel>?) -> (Void) in
            
            DispatchQueue.global(qos: .background).async
            {
                DispatchQueue.main.async
                {
                        let inboxStoryboard = UIStoryboard(name:"Inbox", bundle: nil)
                        
                        let inboxViewController: InboxViewController = inboxStoryboard.instantiateViewController(withIdentifier: "InboxViewController")as! InboxViewController
                      
                        inboxViewController.conversations = conversations
                        
                        self.navigationController?.setViewControllers([inboxViewController], animated: true)
                }
            }
            
        }) { (error:Error?) -> (Void) in
            
            let alert = UIAlertController(title: "Error", message: "Unable to login sucessfully.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }        
    }
    
    @IBAction func rememberMeButton_Tapped(_ sender: Any) {
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
