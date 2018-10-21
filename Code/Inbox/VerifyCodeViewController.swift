//
//  VerifyCodeViewController.swift
//  Inbox
//
//  Created by Amir Akram on 13/10/2018.
//  Copyright © 2018 Amir Akram. All rights reserved.
//

import UIKit

class VerifyCodeViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var numberTextField: FloatLabelTextField!
    
    @IBOutlet weak var header_Label: UILabel!
    @IBOutlet weak var heading2_Label: UILabel!
    @IBOutlet weak var done_Button: UIButton!
    @IBOutlet weak var back_Button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.numberTextField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
        self.numberTextField.delegate = self
        
        // Do any additional setup after loading the view.
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
        
        if (self.numberTextField.text?.isEmpty)!
        {
            let alert = UIAlertController(title:"Warning",message:"Please enter number.",preferredStyle:UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title:"OK",style:UIAlertActionStyle.default,handler:nil))
            
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        var randomString : String = ""

        for _ in 1...4 {
            
            let numberR = Int.random(in: 0 ..< 9)
            randomString = randomString + String(numberR)
        }

        
        ProcessingIndicator.show()
        
        var paramsDic = Dictionary<String, Any>()
        
        paramsDic["mobile"] = self.numberTextField.text
        paramsDic["message"] = randomString
        
        User.verifyNumber(params:paramsDic , completionBlockSuccess: { (status: Bool) -> (Void) in
            DispatchQueue.global(qos: .background).async
                {
                    DispatchQueue.main.async
                        {
                            if status == true {
                                
                                ProcessingIndicator.hide()
//                                let alert = UIAlertController(title: "Sucess", message: "A new password has been sent to your mobile number.", preferredStyle: UIAlertControllerStyle.alert)
//                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
//                                    self.view.removeFromSuperview()
//                                }))
//
//                                self.present(alert, animated: true, completion: nil)
                            }
                            else
                            {
                                ProcessingIndicator.hide()
//                                let alert = UIAlertController(title: "Error", message: "Some error occured, please try again later.", preferredStyle: UIAlertControllerStyle.alert)
//                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//                                self.present(alert, animated: true, completion: nil)
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

}

extension VerifyCodeViewController {
    
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
        self.numberTextField.resignFirstResponder()
        
        return true;
    }
    
}
