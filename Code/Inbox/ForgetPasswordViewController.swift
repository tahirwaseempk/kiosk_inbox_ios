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
        
        
        
    }
    
    @IBAction func backButton_Tapped(_ sender: Any) {
        
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
        
        if textField == self.serialTextField {
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
        udidTextField.resignFirstResponder()
        
        serialTextField.resignFirstResponder()
        
        return true;
    }
    
}

