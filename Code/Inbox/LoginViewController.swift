import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate
{
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var rememberMeButton: UIButton!
    @IBOutlet weak var udidTextField: UITextField!
    @IBOutlet weak var serialTextField: UITextField!
    @IBOutlet weak var fieldsView: UIView!
    
    var isAutoLogin:Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let deviceID = UIDevice.current.identifierForVendor!.uuidString
        self.udidTextField.text = deviceID
        
        // TEST Accounts 'abfc-4f2b' 'test-1234'
        
        self.udidTextField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
        self.serialTextField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
        
        self.udidTextField.isEnabled = false
        self.serialTextField.delegate = self
        
        self.rememberMeButton.backgroundColor = UIColor.clear
        
        if ((UserDefaults.standard.object(forKey:"isAutoKey") as? Bool) != nil) {
            if ((UserDefaults.standard.object(forKey:"isAutoKey") as? Bool) == true) {
                print("########## >>>>>>>>> Auto Login Enabled <<<<<<<<<< ##########")
                self.serialTextField.text = (UserDefaults.standard.object(forKey:"serialKey") as? String)
                login()
            } else {
                print("########## >>>>>>>>> Auto Login not Enabled <<<<<<<<<< ##########")
            }
        }
        
        self.addCheckboxSubviews()
    }
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    func addCheckboxSubviews() {
        
        // tick
        let tickBox = Checkbox(frame: self.rememberMeButton.bounds)
        tickBox.borderColor = UIColor.black
        tickBox.checkmarkColor = UIColor.black
        tickBox.borderStyle = .square
        tickBox.checkmarkStyle = .tick
        tickBox.checkmarkSize = 0.8
        
        if ((UserDefaults.standard.object(forKey:"isAutoKey") as? Bool) != nil) {
            if ((UserDefaults.standard.object(forKey:"isAutoKey") as? Bool) == true) {
                tickBox.isChecked = true
            } else {
                tickBox.isChecked = false
            }
        }else {
            tickBox.isChecked = false
        }
        
        
        tickBox.addTarget(self, action: #selector(circleBoxValueChanged(sender:)), for: .valueChanged)
        self.rememberMeButton.addSubview(tickBox)
    }
    
    @objc func circleBoxValueChanged(sender: Checkbox) {
        
        if sender.isChecked == true {
            isAutoLogin = true
        } else {
            isAutoLogin = false
            UserDefaults.standard.set("", forKey: "serialNumber")
            UserDefaults.standard.set(false, forKey: "isAutoLogin")
            UserDefaults.standard.synchronize()
        }
        
        print("circle box value change: \(sender.isChecked)")
    }
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    @IBAction func loginButton_Tapped(_ sender: Any)
    {
        self.login()
    }
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
}
//************************************************************************************************//
//------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------//
//************************************************************************************************//

extension LoginViewController {
    
    func login()
    {
        if (self.serialTextField.text?.isEmpty)!
        {
            let alert = UIAlertController(title:"Warning",message:"Please enter serial!",preferredStyle:UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title:"OK",style:UIAlertActionStyle.default,handler:nil))
            
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        ProcessingIndicator.show()
        
        User.loginWithUser(serial:self.serialTextField.text!,uuid:self.udidTextField.text!,isRemember:isAutoLogin, completionBlockSuccess:{(user:User?) -> (Void) in
            
            
            User.registerUserAPNS(serial: self.serialTextField.text!, uuid: self.udidTextField.text!, completionBlockSuccess: { (deviceRegistered:Bool) -> (Void) in
                
                DispatchQueue.global(qos: .background).async
                    {
                        DispatchQueue.main.async
                            {
                                //*******************************************************************//
                                //*******************************************************************//
                                //*******************************************************************//
                                if self.isAutoLogin == true {
                                    UserDefaults.standard.set(self.serialTextField.text, forKey: "serialKey")
                                    
                                    UserDefaults.standard.register(defaults: ["isAutoKey" : true])
                                    UserDefaults.standard.bool(forKey: "isAutoKey")
                                    UserDefaults.standard.set(true, forKey: "isAutoKey")
                                    
                                    UserDefaults.standard.synchronize()
                                    
                                } else {
                                    UserDefaults.standard.set("", forKey: "serialKey")

                                    UserDefaults.standard.register(defaults: ["isAutoKey" : true])
                                    UserDefaults.standard.bool(forKey: "isAutoKey")
                                    UserDefaults.standard.set(false, forKey: "isAutoKey")

                                    UserDefaults.standard.synchronize()
                                }
                                //*******************************************************************//
                                //*******************************************************************//
                                //*******************************************************************//
                                ProcessingIndicator.hide()
                                
                                let homeStoryboard = UIStoryboard(name:"Home", bundle: nil)
                                let homeViewController: HomeViewController = homeStoryboard.instantiateViewController(withIdentifier: "HomeViewController")as! HomeViewController
                                self.navigationController?.pushViewController(homeViewController, animated: true)
                        }
                }
                
            }, andFailureBlock: { (error:Error?) -> (Void) in
                
                DispatchQueue.global(qos: .background).async
                    {
                        DispatchQueue.main.async
                            {
                                ProcessingIndicator.hide()
                                
                                let homeStoryboard = UIStoryboard(name:"Home", bundle: nil)
                                let homeViewController: HomeViewController = homeStoryboard.instantiateViewController(withIdentifier: "HomeViewController")as! HomeViewController
                                self.navigationController?.pushViewController(homeViewController, animated: true)
                        }
                }
                
            })
            
            
        }) { (error:Error?) -> (Void) in
            
            DispatchQueue.global(qos:.background).async
                {
                    DispatchQueue.main.async
                        {
                            ProcessingIndicator.hide()
                            
                            let alert = UIAlertController(title:"Error!",message:"Unable to login",preferredStyle: UIAlertControllerStyle.alert)
                            
                            alert.addAction(UIAlertAction(title:"OK",style:UIAlertActionStyle.default,handler: nil))
                            
                            self.present(alert,animated:true,completion:nil)
                    }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        udidTextField.resignFirstResponder()
        
        serialTextField.resignFirstResponder()
        
        return true;
    }
}


extension LoginViewController {
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if textField == serialTextField{
            
            return checkEnglishPhoneNumberFormat(string: string, str: str)
            
        } else {
            
            return true
        }
    }
    
    func checkEnglishPhoneNumberFormat(string: String?, str: String?) -> Bool{
        
        if string == ""{ //BackSpace
            
            return true
            
        }else if str!.count == 5 {
            
            serialTextField.text = serialTextField.text! + "-"
       
        }else if str!.count > 9 {
            
            return false
            
        }
        
        return true
    }
}

