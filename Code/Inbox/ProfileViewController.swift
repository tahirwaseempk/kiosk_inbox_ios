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
            self.usernameLabel.text        = " Username: " + user.username!
           
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
        
        addLineToView(view: self.nameTextField, position:.LINE_POSITION_BOTTOM, width: TEXTFIELD_LINE_WIDTH)
        addLineToView(view: self.lastnameTextField, position:.LINE_POSITION_BOTTOM, width: TEXTFIELD_LINE_WIDTH)
        addLineToView(view: self.emailTextField, position:.LINE_POSITION_BOTTOM, width: TEXTFIELD_LINE_WIDTH)
        addLineToView(view: self.mobileTextField, position:.LINE_POSITION_BOTTOM, width: TEXTFIELD_LINE_WIDTH)
        addLineToView(view: self.timeZoneTextField, position:.LINE_POSITION_BOTTOM, width: TEXTFIELD_LINE_WIDTH)
        addLineToView(view: self.companyNameTextField, position:.LINE_POSITION_BOTTOM, width: TEXTFIELD_LINE_WIDTH)
        addLineToView(view: self.addressTextField, position:.LINE_POSITION_BOTTOM, width: TEXTFIELD_LINE_WIDTH)
        addLineToView(view: self.cityTextField, position:.LINE_POSITION_BOTTOM, width: TEXTFIELD_LINE_WIDTH)
        addLineToView(view: self.stateTextField, position:.LINE_POSITION_BOTTOM, width: TEXTFIELD_LINE_WIDTH)
        addLineToView(view: self.zipCodeTextField, position:.LINE_POSITION_BOTTOM, width: TEXTFIELD_LINE_WIDTH)
        addLineToView(view: self.countryTextField, position:.LINE_POSITION_BOTTOM, width: TEXTFIELD_LINE_WIDTH)

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    @IBAction func doneButton_Tapped(_ sender: Any) {
        
        if (self.nameTextField.text?.isEmpty)!
        {
            let alert = UIAlertController(title:"Warning",message:"Please enter name.",preferredStyle:UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title:"OK",style:UIAlertActionStyle.default,handler:nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
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
                                let alert = UIAlertController(title: "Sucess", message: "User updated sucessfully.", preferredStyle: UIAlertControllerStyle.alert)
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
    
    
    @IBAction func backButton_Tapped(_ sender: Any) {
    }
    
}
