import UIKit
import Contacts

class UploadContactViewController: UIViewController
{
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.setupControls()
    }
    
    func setupControls()
    {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        cornerRadius()
    }
       
    func cornerRadius()
    {
        self.continueButton.layer.cornerRadius = self.continueButton.bounds.size.height / 2.0
    }
    
    @IBAction func backButton_Tapped(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated:true)
    }
    
    @IBAction func continueButon_Tapped(_ sender: UIButton)
    {
        if sender.tag == 0
        {
            self.uploadContacts()
        }
        else
        {
            self.backButton_Tapped(self.backButton)
        }
    }
    
    func uploadContacts()
    {
        requestAccess { (responce) in
             if responce
             {
                self.fetchPhoneBookContacts()
             }
             else
             {
                self.showContactFetchingError(errorMsg:"Access Denied, Please allow to fetch contacts from phoneBook")
             }
         }
    }
    
    func fetchPhoneBookContacts()
    {
      fetchContacts(ContactsSortorder: .givenName) { (result) in
         
          switch result
          {
              case .success(response: let contacts):
                  
                  self.convertToCSV(contacts)
                  
                  print(contacts)
                  break
              
              case .failure(error: let error):
                  self.showContactFetchingError(errorMsg:error.localizedDescription)
                  break
          }
      }
    }
    
    func convertToCSV(_ contacts:Array<CNContact>)
    {
        contactsToVCardConverter(contacts:contacts) { (result) in
            
            DispatchQueue.global(qos: .background).async
            {
                DispatchQueue.main.async
                {
                   switch result
                    {
                        case .success(response: let data): //.vcf File
                            
                            self.uploadContacts(contactsVCFData:data)
                            break
                     
                        case .failure(error: let error):
                            self.showContactFetchingError(errorMsg:error.localizedDescription)
                            break
                    }
                }
            }
               
           }
    }
    
    func uploadContacts(contactsVCFData:Data)
    {
        ProcessingIndicator.show()

        UserContact.uploadContacts(contactsCSVData:contactsVCFData, completionBlockSuccess:
        { (status:Bool) -> (Void) in
            DispatchQueue.global(qos: .background).async
            {
                DispatchQueue.main.async
                {
                    self.contactUploadedSuccessfullyView()

                    ProcessingIndicator.hide()
                }
            }
            
        }) { (error:Error?) -> (Void) in
            
            DispatchQueue.global(qos: .background).async
            {
                DispatchQueue.main.async
                {
                    ProcessingIndicator.hide()
                    
                    let alert = UIAlertController(title:"Error",message:error?.localizedDescription,preferredStyle: UIAlertControllerStyle.alert)
                    
                    let okAction = UIAlertAction(title:"OK", style:.default) { (action:UIAlertAction) in
                        
                    }
                    
                    alert.addAction(okAction)
                    
                    self.present(alert,animated:true,completion:nil)
                }
            }
        }
    }
    
    func contactUploadedSuccessfullyView()
    {
        self.continueButton.tag = 1
        
        self.messageLabel.text = "Thank you, your contacts have been imported successfully"
        
        self.logoImageView.isHighlighted = true
    }
    
    func showContactFetchingError(errorMsg:String)
    {
        let alert = UIAlertController(title:"Error!", message:errorMsg, preferredStyle: .alert)
      
        alert.addAction(UIAlertAction(title:"OK", style:.cancel, handler:nil))

        self.present(alert, animated: true)
    }
}
