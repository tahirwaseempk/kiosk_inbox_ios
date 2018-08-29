import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate
{
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var rememberMeButton: UIButton!
    @IBOutlet weak var udidTextField: UnderlinedTextField!
    @IBOutlet weak var serialTextField: UnderlinedTextField!
    @IBOutlet weak var fieldsView: UIView!
    
    @IBOutlet weak var loginImageView: UIImageView!
    @IBOutlet weak var serialLabel: UILabel!
    @IBOutlet weak var udidLabel: UILabel!
        
    var isAutoLogin:Bool = false
    
    var tickBox:Checkbox? = nil
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        switch environment {
        case .texting_Line:
            loginImageView.image = UIImage(named: "LoginImage")
            self.view.backgroundColor = UIColor.white
            loginButton.backgroundColor = AppBlueColor
            loginButton.setTitleColor(UIColor.white, for: UIControlState.normal)
            serialLabel.textColor = AppBlueColor
            udidLabel.textColor = AppBlueColor
        case .sms_Factory:
            loginImageView.image = UIImage(named: "smsfactory")
            self.view.backgroundColor = AppBlueColor
            loginButton.backgroundColor = UIColor.white
            loginButton.setTitleColor(UIColor.black, for: UIControlState.normal)
            serialLabel.textColor = UIColor.black
            udidLabel.textColor = UIColor.black
        case .fan_Connect:
            loginImageView.image = UIImage(named: "Fan_Login")
            self.view.backgroundColor = UIColor.white
            loginButton.backgroundColor = FanAppColor
            loginButton.setTitleColor(UIColor.white, for: UIControlState.normal)
            serialLabel.textColor = FanAppColor
            udidLabel.textColor = FanAppColor
        case .photo_Texting:
            loginImageView.image = UIImage(named: "Photo_Login")
            self.view.backgroundColor = UIColor.white
            loginButton.backgroundColor = PhotoAppColor
            loginButton.setTitleColor(UIColor.white, for: UIControlState.normal)
            serialLabel.textColor = PhotoAppColor
            udidLabel.textColor = PhotoAppColor
        }
        
        self.udidTextField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
        self.serialTextField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
        
        self.udidTextField.isEnabled = true
        self.serialTextField.delegate = self
        self.udidTextField.delegate = self

        self.rememberMeButton.backgroundColor = UIColor.clear
        
        self.loginButton.clipsToBounds = true
        
        self.loginButton.layer.cornerRadius = self.loginButton.frame.size.height / 8.0
        
        if ((UserDefaults.standard.object(forKey:"isAutoKey") as? Bool) != nil) {
            if ((UserDefaults.standard.object(forKey:"isAutoKey") as? Bool) == true) {
                print("########## >>>>>>>>> Auto Login Enabled <<<<<<<<<< ##########")
                self.isAutoLogin = true
                self.serialTextField.text = (UserDefaults.standard.object(forKey:"USER_NAME") as? String)
                self.udidTextField.text = (UserDefaults.standard.object(forKey:"PASSWORD") as? String)
                login()
            } else {
                self.isAutoLogin = false
                print("########## >>>>>>>>> Auto Login not Enabled <<<<<<<<<< ##########")
            }
        }
        
//        serialTextField.text = "8443712030"
//        udidTextField.text = "lime123"
        
        self.addCheckboxSubviews()
    }
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        if self.tickBox != nil
        {
            self.tickBox?.frame = self.rememberMeButton.bounds
        }
    }
    
    func addCheckboxSubviews() {
        
        // tick
        self.tickBox = Checkbox(frame: self.rememberMeButton.bounds)
        self.tickBox?.borderColor = UIColor.black
        self.tickBox?.checkmarkColor = UIColor.black
        self.tickBox?.borderStyle = .square
        self.tickBox?.checkmarkStyle = .tick
        self.tickBox?.checkmarkSize = 0.8
        
        if ((UserDefaults.standard.object(forKey:"isAutoKey") as? Bool) != nil) {
            if ((UserDefaults.standard.object(forKey:"isAutoKey") as? Bool) == true) {
                self.tickBox?.isChecked = true
            } else {
                self.tickBox?.isChecked = false
            }
        }else {
            self.tickBox?.isChecked = false
        }
        
        
        self.tickBox?.addTarget(self, action: #selector(circleBoxValueChanged(sender:)), for: .valueChanged)
        
        self.rememberMeButton.addSubview(self.tickBox!)
    }
    
    @objc func circleBoxValueChanged(sender: Checkbox) {
        
        if sender.isChecked == true {
            self.isAutoLogin = true
        } else {
            self.isAutoLogin = false
            UserDefaults.standard.set("", forKey: "USER_NAME")
            UserDefaults.standard.set("", forKey: "PASSWORD")
            UserDefaults.standard.bool(forKey: "isAutoKey")
            UserDefaults.standard.set(false, forKey: "isAutoKey")
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
        
        User.loginWithUser(username:self.serialTextField.text!,password:self.udidTextField.text!,isRemember:isAutoLogin, completionBlockSuccess:{(user:User?) -> (Void) in
            
            User.registerUserAPNS(license: (user?.license)!, completionBlockSuccess: { (deviceRegistered:Bool) -> (Void) in
                
                DispatchQueue.global(qos: .background).async
                    {
                        DispatchQueue.main.async
                            {
                                //*******************************************************************//
                                //*******************************************************************//
                                //*******************************************************************//
                                if self.isAutoLogin == true {
                                    UserDefaults.standard.set(self.serialTextField.text, forKey: "USER_NAME")
                                    UserDefaults.standard.set(self.udidTextField.text, forKey: "PASSWORD")
                                    UserDefaults.standard.register(defaults: ["isAutoKey" : true])
                                    UserDefaults.standard.bool(forKey: "isAutoKey")
                                    UserDefaults.standard.set(true, forKey: "isAutoKey")
                                    UserDefaults.standard.synchronize()
                                    
                                } else {
                                    UserDefaults.standard.set("", forKey: "USER_NAME")
                                    UserDefaults.standard.set("", forKey: "PASSWORD")
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
                                //*******************************************************************//
                                //*******************************************************************//
                                //*******************************************************************//
                                if self.isAutoLogin == true {
                                    UserDefaults.standard.set(self.serialTextField.text, forKey: "USER_NAME")
                                    UserDefaults.standard.set(self.udidTextField.text, forKey: "PASSWORD")
                                    UserDefaults.standard.register(defaults: ["isAutoKey" : true])
                                    UserDefaults.standard.bool(forKey: "isAutoKey")
                                    UserDefaults.standard.set(true, forKey: "isAutoKey")
                                    UserDefaults.standard.synchronize()
                                    
                                } else {
                                    UserDefaults.standard.set("", forKey: "USER_NAME")
                                    UserDefaults.standard.set("", forKey: "PASSWORD")
                                    UserDefaults.standard.register(defaults: ["isAutoKey" : true])
                                    UserDefaults.standard.bool(forKey: "isAutoKey")
                                    UserDefaults.standard.set(false, forKey: "isAutoKey")
                                    UserDefaults.standard.synchronize()
                                    self.serialTextField.text = ""
                                    self.udidTextField.text = ""
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
                
            })
            
            
        }) { (error:Error?) -> (Void) in
            
            DispatchQueue.global(qos:.background).async
                {
                    DispatchQueue.main.async
                        {
                            ProcessingIndicator.hide()
                            
                            self.serialTextField.text = ""
                            self.udidTextField.text = ""

                            let alert = UIAlertController(title:"Error",message:error?.localizedDescription,preferredStyle: UIAlertControllerStyle.alert)
                            
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
        
//        if textField == serialTextField{
//
//            return checkEnglishPhoneNumberFormat(string: string, str: str)
//
//        } else {
//
            return true
//        }
    }
    
    func checkEnglishPhoneNumberFormat(string: String?, str: String?) -> Bool{
        
        if string == ""
        {
            //BackSpace
            
            if str!.count == 4
            {
                let truncated = str!.substring(to: str!.index(before: str!.endIndex))
                
                serialTextField.text =  truncated
                
                return false
            }
            
            return true
        }
        else if str!.count == 4
        {
            serialTextField.text = serialTextField.text! + string! + "-"
            
            return false
            
        }else if str!.count > 9 {
            
            return false
        }
        
        return true
    }
    
}

