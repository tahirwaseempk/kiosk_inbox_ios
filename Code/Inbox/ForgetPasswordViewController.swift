//
//  ForgetPasswordViewController.swift
//  Inbox
//
//  Created by Amir Akram on 13/10/2018.
//  Copyright © 2018 Amir Akram. All rights reserved.
//

import UIKit

class ForgetPasswordViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var numberTextField: UnderlinedTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func doneButton_Tapped(_ sender: Any) {

        if (self.numberTextField.text?.isEmpty)!
        {
            let alert = UIAlertController(title:"Warning",message:"Please enter phone number",preferredStyle:UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title:"OK",style:UIAlertActionStyle.default,handler:nil))
            
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        ProcessingIndicator.show()

        var paramsDic = Dictionary<String, Any>()
        
        paramsDic["mobile"] = self.numberTextField.text
        
        User.forgetUserPassword(params:paramsDic , completionBlockSuccess: { (status: Bool) -> (Void) in
            DispatchQueue.global(qos: .background).async
                {
                    DispatchQueue.main.async
                        {
                            if status == true {
                               
                                ProcessingIndicator.hide()
                                let alert = UIAlertController(title: "Sucess", message: "Password sent on your mobile number..", preferredStyle: UIAlertControllerStyle.alert)
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
                            self.numberTextField.text = ""
                            let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                    }
            }
        })
        
    }
    
    @IBAction func backButton_Tapped(_ sender: Any) {
        
        self.view.removeFromSuperview()

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

extension ForgetPasswordViewController {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.numberTextField {
            let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_DIGITS).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            let isAllowed = (string == filtered)
            
            if isAllowed == false {
                return false
            }
            
            if str.count > PHONENUMBER_MAX_LENGTH {
                return false
            }
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        numberTextField.resignFirstResponder()
        
        return true;
    }
    
}

