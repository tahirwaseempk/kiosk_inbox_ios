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
        
        
        WebManager.requestLogin(params: Dictionary(), completionBlockSuccess: { (response:AnyObject?) -> (Void) in
            
            let json = response as! Dictionary<String,Any>
            
            json.printJson()
            
            let homeStoryboard = UIStoryboard(name:"Inbox", bundle: nil)
            
            let homeViewController: UIViewController = homeStoryboard.instantiateViewController(withIdentifier: "InboxViewController")as! InboxViewController
            self.navigationController?.setViewControllers([homeViewController], animated: true)
            
            
        }) { (error:Error?) -> (Void) in
            
            
            
            
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
