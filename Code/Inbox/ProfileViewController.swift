//
//  ProfileViewController.swift
//  Inbox
//
//  Created by Amir Akram on 13/10/2018.
//  Copyright © 2018 Amir Akram. All rights reserved.
//

import UIKit
import SwiftyPickerPopover

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
    
    @IBOutlet weak var profileDoneButton: UIButton!
    @IBOutlet weak var profileNavHeaderLabel: UILabel!    
    @IBOutlet weak var profileBackButton: UIButton!
    @IBOutlet weak var profileNavView: UIView!
    
    private var selectedStateRow: Int = 0
    private var selectedCountryRow: Int = 0

    
    @IBAction func stateButton_Tapped(_ sender: UIButton) {
        
        let p = StringPickerPopover(title: "Select State", choices: ["FL","AA","AE","AK","AL","AP","AR","AS","AZ","CA","CO","CT","DC","DE","FM","GA","GU","HI","IA","ID","IL","IN","KS","KY","LA","MA","MD","ME","MH","MI","MN","MO","MP","MS","MT","NC","ND","NE","NH","NJ","NM","NV","NY","OH","OK","OR","PA","PR","PW","RI","SC","SD","TN","TX","UT","VA","VI","VT","WA","WI","WV","WY"])
            // .setDisplayStringFor(displayStringFor)
            .setValueChange(action: { _, _, selectedString in
                print("current string: \(selectedString)")
            })
            //.setFontSize(16)
            .setDoneButton(
                action: { popover, selectedRow, selectedString in
                    print("done row \(selectedRow) \(selectedString)")
                    self.selectedStateRow = selectedRow
                    self.stateTextField.text = selectedString
                    
            })
            .setCancelButton(action: {_, _, _ in
                print("cancel") })
            .setSelectedRow(self.selectedStateRow)
        p.appear(originView: sender, baseViewController: self)
        p.disappearAutomatically(after: 3.0, completion: { print("automatically hidden")} )
        
    }
    
    @IBAction func countryButton_Tapped(_ sender: UIButton) {
        
        let p = StringPickerPopover(title: "Select State", choices: ["Canada","United States of America"])
            // .setDisplayStringFor(displayStringFor)
            .setValueChange(action: { _, _, selectedString in
                print("current string: \(selectedString)")
            })
            //.setFontSize(16)
            .setDoneButton(
                action: { popover, selectedRow, selectedString in
                    print("done row \(selectedRow) \(selectedString)")
                    self.selectedCountryRow = selectedRow
                    self.countryTextField.text = selectedString
                    
            })
            .setCancelButton(action: {_, _, _ in
                print("cancel") })
            .setSelectedRow(self.selectedCountryRow)
        p.appear(originView: sender, baseViewController: self)
        p.disappearAutomatically(after: 3.0, completion: { print("automatically hidden")} )
        
    }
    
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
        
        self.profileDoneButton.layer.cornerRadius = self.profileDoneButton.bounds.height/BUTTON_RADIUS

        
        if let user = User.getLoginedUser()
        {
            self.usernameLabel.text        = user.formattedUsername!
            
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
        
        self.nameTextField.layer.sublayerTransform        = CATransform3DMakeTranslation(8, 0, 0)
        self.lastnameTextField.layer.sublayerTransform    = CATransform3DMakeTranslation(8, 0, 0)
        self.emailTextField.layer.sublayerTransform       = CATransform3DMakeTranslation(8, 0, 0)
        self.mobileTextField.layer.sublayerTransform      = CATransform3DMakeTranslation(8, 0, 0)
        self.timeZoneTextField.layer.sublayerTransform    = CATransform3DMakeTranslation(8, 0, 0)
        self.companyNameTextField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
        self.addressTextField.layer.sublayerTransform     = CATransform3DMakeTranslation(8, 0, 0)
        self.cityTextField.layer.sublayerTransform        = CATransform3DMakeTranslation(8, 0, 0)
        self.stateTextField.layer.sublayerTransform       = CATransform3DMakeTranslation(8, 0, 0)
        self.zipCodeTextField.layer.sublayerTransform     = CATransform3DMakeTranslation(8, 0, 0)
        self.countryTextField.layer.sublayerTransform     = CATransform3DMakeTranslation(8, 0, 0)

        self.timeZoneTextField.isEnabled = false
        self.stateTextField.isEnabled    = false
        self.countryTextField.isEnabled  = false
        
        
        
        //self.view.backgroundColor = AppThemeColor
       // self.profileNavView.backgroundColor = AppThemeColor
        
        
//                switch environment {
//                case .texting_Line:
//                    self.view.backgroundColor = AppThemeColor
//                    profileBackButton.setTitleColor(.white, for: .normal)
//                case .sms_Factory:
//                    self.view.backgroundColor = AppThemeColor
//                    profileBackButton.setTitleColor(.white, for: .normal)
//                case .fan_Connect:
//                    self.view.backgroundColor = AppThemeColor
//                    profileBackButton.setTitleColor(.white, for: .normal)
//                case .photo_Texting:
//                    self.view.backgroundColor = AppThemeColor
//                    profileBackButton.setTitleColor(.white, for: .normal)
//                case .text_Attendant:
//                    self.view.backgroundColor = AppThemeColor
//                    profileBackButton.setTitleColor(.white, for: .normal)
//
//        }
        
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
