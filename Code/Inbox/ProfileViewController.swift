//
//  ProfileViewController.swift
//  Inbox
//
//  Created by Amir Akram on 13/10/2018.
//  Copyright © 2018 Amir Akram. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameTextField: FloatLabelTextField!
    @IBOutlet weak var lastnameTextField: FloatLabelTextField!
    @IBOutlet weak var emailTextField: FloatLabelTextField!
    @IBOutlet weak var mobileTextField: FloatLabelTextField!
    @IBOutlet weak var timeZoneTextField: FloatLabelTextField!
    @IBOutlet weak var companyNameTextField: FloatLabelTextField!
    @IBOutlet weak var addressTextField: FloatLabelTextField!
    @IBOutlet weak var cityTextField: FloatLabelTextField!
    @IBOutlet weak var stateTextField: FloatLabelTextField!
    @IBOutlet weak var zipCodeTextField: FloatLabelTextField!
    @IBOutlet weak var countryTextField: FloatLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        if let user = User.getLoginedUser()
        {
            self.usernameLabel.text        = " Username " + user.username!
            self.nameTextField.text        = user.firstName!
            self.lastnameTextField.text    = user.lastName!
            self.emailTextField.text       = user.lastName!
            self.mobileTextField.text      = user.mobile!
            self.timeZoneTextField.text    = String(user.timezone)
            self.companyNameTextField.text = user.companyName!
            self.addressTextField.text     = user.address!
            self.cityTextField.text        = user.city!
            self.stateTextField.text       = user.state!
            self.zipCodeTextField.text     = user.zipCode!
            self.countryTextField.text     = user.country!
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
