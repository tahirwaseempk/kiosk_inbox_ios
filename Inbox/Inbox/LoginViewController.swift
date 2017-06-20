//
//  LoginViewController.swift
//  Inbox
//
//  Created by tahir on 20/06/2017.
//  Copyright © 2017 Amir Akram. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBAction func loginButton_Tapped(_ sender: Any) {
    }
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var rememberMeButton: UIButton!
    @IBOutlet weak var udidTextField: UITextField!
    @IBOutlet weak var serialTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
