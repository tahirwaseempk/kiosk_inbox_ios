//
//  ProfileViewController.swift
//  Inbox
//
//  Created by Amir Akram on 13/10/2018.
//  Copyright © 2018 Amir Akram. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    //MARK: IBOutlets
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
    
    //MARK: View life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        var timeZones = [Int: String]()
        timeZones[1] = "Eastern Time"
        timeZones[2] = "Central Time"
        timeZones[3] = "Mountain Time"
        timeZones[4] = "Pacific Time"
        timeZones[5] = "Alaskan Time"
        timeZones[6] = "Hawaiian Time"
        timeZones[7] = "Arizona Time"
        
        
        if let user = User.getLoginedUser()
        {
            self.usernameLabel.text        = " Username: " + user.username!
            
            self.nameTextField.text        = user.firstName!
            self.lastnameTextField.text    = user.lastName!
            self.emailTextField.text       = user.email!
            self.mobileTextField.text      = user.mobile!
            if user.timezone > 0 {
                self.timeZoneTextField.text =  timeZones[Int(user.timezone)]
            }
            self.companyNameTextField.text = user.companyName!
            self.addressTextField.text     = user.address!
            self.cityTextField.text        = user.city!
            self.stateTextField.text       = user.state!
            self.zipCodeTextField.text     = user.zipCode!
            self.countryTextField.text     = user.country!
        }
        
        self.nameTextField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
        self.lastnameTextField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
        self.emailTextField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
        self.mobileTextField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
        self.timeZoneTextField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
        self.companyNameTextField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
        self.addressTextField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
        self.cityTextField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
        self.stateTextField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
        self.zipCodeTextField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
        self.countryTextField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)

        self.timeZoneTextField.isEnabled = false
        self.stateTextField.isEnabled    = false
        self.countryTextField.isEnabled  = false
        
        switch environment {
        case .texting_Line:
            self.view.backgroundColor = AppBlueColor
        case .sms_Factory:
            self.view.backgroundColor = AppBlueColor
        case .fan_Connect:
            self.view.backgroundColor = FanAppColor
        case .photo_Texting:
            self.view.backgroundColor = PhotoAppColor
        }
        
    }

    // MARK: Actions
    @IBAction func doneButton_Tapped(_ sender: Any) {
       
        self.nameTextField.resignFirstResponder()
        self.lastnameTextField.resignFirstResponder()
        self.emailTextField.resignFirstResponder()
        self.mobileTextField.resignFirstResponder()
        self.timeZoneTextField.resignFirstResponder()
        self.companyNameTextField.resignFirstResponder()
        self.addressTextField.resignFirstResponder()
        self.cityTextField.resignFirstResponder()
        self.stateTextField.resignFirstResponder()
        self.zipCodeTextField.resignFirstResponder()
        self.countryTextField.resignFirstResponder()

        if (self.nameTextField.text?.isEmpty)!
        {
            let alert = UIAlertController(title:"Warning",message:"Please enter first name.",preferredStyle:UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title:"OK",style:UIAlertActionStyle.default,handler:nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        callWebServiceProfileUpdate()
    }
    
    @IBAction func backButton_Tapped(_ sender: Any) {
        
        self.view.removeFromSuperview()
    }
    
}


extension ProfileViewController {
    
    func callWebServiceProfileUpdate() {
      
        ProcessingIndicator.show()
        
        var paramsDic = Dictionary<String, Any>()
        paramsDic["firstName"]   = self.nameTextField.text
        paramsDic["lastName"]    = self.lastnameTextField.text
        paramsDic["email"]       = self.emailTextField.text
        paramsDic["mobile"]      = self.mobileTextField.text
        paramsDic["companyName"] = self.companyNameTextField.text
        paramsDic["address"]     = self.addressTextField.text
        paramsDic["city"]        = self.cityTextField.text
        paramsDic["state"]       = self.stateTextField.text
        paramsDic["zipCode"]     = self.zipCodeTextField.text
        paramsDic["country"]     = self.countryTextField.text
        
        User.updateUser(params:paramsDic , completionBlockSuccess: { (status: Bool) -> (Void) in
            DispatchQueue.global(qos: .background).async
                {
                    DispatchQueue.main.async
                        {
                            if status == true {
                                
                                ProcessingIndicator.hide()
                                let alert = UIAlertController(title: "Success", message: "User updated sucessfully.", preferredStyle: UIAlertControllerStyle.alert)
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
    }
}
