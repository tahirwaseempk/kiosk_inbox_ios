import UIKit
import Foundation
import SwiftyPickerPopover

class ContactDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    let headerColor = UIColor.init(displayP3Red:0.96, green:0.97, blue:1.0, alpha:1.0)

    var contact:UserContact!
    
    var createTageView: CreateTagView!
    
    var delegate:ContactDetailViewControllerDelegate?
    
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var headerContactNumberLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveDetailButton: UIButton!
    
    @IBOutlet weak var composeMessageButton: UIButton!
    var FirstNameValue = ""
    
    var LastNameValue = ""
    
    var EmailValue = ""
    
    var DOBValue:Date?
    
    var GenderValue = ""
    
    var AddressValue = ""
    
    var StateValue = ""
    
    var ZipCodeValue = ""
    
    var shouldShowComposeButton = true
    
    var composeMessageViewController:ComposeMessageViewController!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.setupControls()
    }
    
    func setupControls()
    {
        if #available(iOS 13.0, *)
        {
            overrideUserInterfaceStyle = .light
        }
        
        if shouldShowComposeButton == false
        {
            self.composeMessageButton.isHidden = true
        }
        
        self.createTageView = CreateTagView.instanceFromNib(delegate:self)
                    
        self.loadData()
    }
    
    func loadData()
    {
        if let firstName = self.contact.firstName
        {
            self.FirstNameValue = firstName
        }

        if let lastName = self.contact.lastName
        {
            self.LastNameValue = lastName
        }

        if let email = self.contact.email
        {
            self.EmailValue = email
        }

        if let cDoB = self.contact.birthDate
        {
            self.DOBValue = cDoB
        }
        
        //self.DOBValue = self.contact.birthDate

        if let gender = self.contact.gender
        {
            self.GenderValue = gender
        }

        if let address = self.contact.address
        {
            self.AddressValue = address
        }

        if let state = self.contact.state
        {
            self.StateValue = state
        }

        if let zipCode = self.contact.zipCode
        {
            self.ZipCodeValue = zipCode
        }

        self.headerContactNumberLabel.text = self.contact.phoneNumber
        
        self.tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        cornerRadius()
    }
    
    func cornerRadius()
    {
        self.saveDetailButton.layer.cornerRadius = self.saveDetailButton.bounds.size.height / 2.0
        
        //self.createTagAlertView.layer.cornerRadius = 5.0
    }
    
    @IBAction func backButtonTapped(_ sender: Any)
    {
        self.view.endEditing(true)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func createTagButton_Tapped(_ sender: Any)
    {
        self.createTageView.frame = self.view.bounds
        
        self.view.addSubview(self.createTageView)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 2
        {
            return 150
        }
        
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0
        {
            return 5
        }
        else if section == 1
        {
            return 3
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let header = UIView.init(frame:CGRect(x:0, y:0, width:tableView.bounds.size.width, height:30.0))
        
        header.backgroundColor = headerColor
        
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0 || indexPath.section == 1
        {
            let cell:ContactNameTableViewCell =  tableView.dequeueReusableCell(withIdentifier:"ContactsListTableViewCell", for:indexPath) as! ContactNameTableViewCell
            
            cell.loadCell(FirstNameValue:self.FirstNameValue, LastNameValue:self.LastNameValue, EmailValue:self.EmailValue, DOBValue:self.DOBValue, GenderValue:self.GenderValue, AddressValue:self.AddressValue, StateValue:self.StateValue, ZipCodeValue:self.ZipCodeValue, indexPath:indexPath, delegate:self)

            return cell
        }
        else if indexPath.section == 2
        {
            let cell:ContactTagTableViewCell =  tableView.dequeueReusableCell(withIdentifier:"ContactTagTableViewCell", for:indexPath) as! ContactTagTableViewCell
            
            cell.delegate = self
            
            cell.loadCell(fromContact:self.contact)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
       
    }
}

extension ContactDetailViewController:CreateTagViewDelegate
{
    func tagCreated()
    {
        self.loadData()
    }
}

extension ContactDetailViewController:ContactTagTableViewCellDelegate
{
    func addTagTapped()
    {
        self.createTageView.frame = self.view.bounds
        
        self.createTageView.contacts = [self.contact]
        
        self.view.addSubview(self.createTageView)
    }
    
    func deleteTagTapped(_ tagToDelete:Tag)
    {
        let alert = UIAlertController(title: "Confirm", message: "Are you sure you want to delete the tag: " + tagToDelete.tagName!, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in

            self.deleteTag(tagToDelete)
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }
    
    func deleteTag(_ tagObj: Tag)
    {
        ProcessingIndicator.show()

      //  UserContact.deleteContacts(contacts:[self.contact], completionBlockSuccess: { (status:Bool) -> (Void) in
        
        Tag.deleteTag(tagToDelete: tagObj, completionBlockSuccess: { (status: Bool) -> (Void) in
    
            DispatchQueue.global(qos: .background).async
            {
                DispatchQueue.main.async
                {
                    self.tableView.reloadData()
                    
                    ProcessingIndicator.hide()
                                           
                    let alert = UIAlertController(title:"Tag Deleted ",message:"Contact deleted successfully.",preferredStyle: UIAlertControllerStyle.alert)
                       
                    let okAction = UIAlertAction(title:"OK", style:.default) { (action:UIAlertAction) in
                        self.navigationController?.popViewController(animated:true)
                    }
                               
                    alert.addAction(okAction)
                               
                    self.present(alert,animated:true,completion:nil)
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
}

extension ContactDetailViewController
{
    @IBAction func deleteTagButton_Tapped(_ sender: Any)
    {
        if self.contact != nil
        {
            let alert = UIAlertController(title: "Alert", message: "Are you sure you want to delete these contact ", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
                
                self.deleteContacts()
            }))
            
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

            self.present(alert, animated: true)
        }
        else
        {
            let alert = UIAlertController(title: "Alert", message: "Selected contact does not exist anymore, please refresh page", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

            self.present(alert, animated: true)
        }
        
    }
    
    func deleteContacts()
    {
        ProcessingIndicator.show()

        UserContact.deleteContacts(contacts:[self.contact], completionBlockSuccess: { (status:Bool) -> (Void) in
            DispatchQueue.global(qos: .background).async
            {
                DispatchQueue.main.async
                {
                    self.deleteContactsFromLocalArrays(contactToRemove:self.contact)

                    ProcessingIndicator.hide()
                       
                    let alert = UIAlertController(title:"Contact Deleted ",message:"Contact deleted successfully",preferredStyle: UIAlertControllerStyle.alert)
                       
                    let okAction = UIAlertAction(title:"OK", style:.default) { (action:UIAlertAction) in
                        self.navigationController?.popViewController(animated:true)
                    }
                               
                    alert.addAction(okAction)
                               
                    self.present(alert,animated:true,completion:nil)
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
    
    func deleteContactsFromLocalArrays(contactToRemove:UserContact)
    {
        if let delegate = self.delegate
        {
            delegate.deleteContactsFromLocalArrays(contactsToRemove:[contactToRemove])
        }
    }
}

extension ContactDetailViewController : ContactNameTableViewCellDelegate
{
    func updatedFirstNameField(_ newValue:String)
    {
        self.FirstNameValue = newValue
        
        self.tableView.reloadData()
        
        self.refreshData()
    }
    
    func updatedLastNameField(_ newValue:String)
    {
        self.LastNameValue = newValue
        
        self.refreshData()
    }
    
    func updatedEmailField(_ newValue:String)
    {
        self.EmailValue = newValue
        
        self.refreshData()
    }
    
    func updatedDOBField(_ newValue:Date)
    {
        self.DOBValue = newValue
        
        self.refreshData()
    }
    
    func updatedGenderField(_ newValue:String)
    {
        self.GenderValue = newValue
        
        self.refreshData()
    }
    
    func updatedAddressField(_ newValue:String)
    {
        self.AddressValue = newValue
        
        self.refreshData()
    }
    
    func updatedStateField(_ newValue:String)
    {
        self.StateValue = newValue
        
        self.refreshData()
    }
    
    func updatedZipCodeField(_ newValue:String)
    {
        self.ZipCodeValue = newValue
        
        self.refreshData()
    }
    
    func refreshData()
    {
        self.tableView.reloadData()
    }
}

extension ContactDetailViewController
{
    @IBAction func saveContactDetailButton_Tapped(_ sender: Any)
    {
        if self.validateInputs() == true
        {
            self.saveProfileData()
        }
    }

    func validateInputs() -> Bool
    {
        if let firstName = self.contact.firstName, firstName.isEmpty == true
        {
            let alert = UIAlertController(title:"Warning",message:"Please enter first name.",preferredStyle:UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title:"OK",style:UIAlertActionStyle.default,handler:nil))
            
            self.present(alert, animated: true, completion: nil)
            
            return false
        }

        return true
    }
    
    func saveProfileData()
    {
        ProcessingIndicator.show()
        
        var paramsDic = Dictionary<String,Any>()
        
        paramsDic["contactID"] = String(contact.contactId)

        paramsDic["firstName"] = self.FirstNameValue

        paramsDic["lastName"] = self.LastNameValue

        paramsDic["gender"] = self.GenderValue

        paramsDic["email"] = self.EmailValue

        paramsDic["address"] = self.AddressValue

        paramsDic["state"] = self.StateValue

        paramsDic["zipCode"] = self.ZipCodeValue

        if let dob = self.DOBValue
        {
            let utcFormatter = DateFormatter()
            utcFormatter.dateFormat = UTC_DATE_TIME_APPOINTMENT
            utcFormatter.timeZone = TimeZone(abbreviation: "UTC")
            let utcTimeZoneStr = utcFormatter.string(from: dob)
           
            if  utcTimeZoneStr == "68000-07-10T08:00:00Z"{
                paramsDic["birthDate"] = ""
            } else {
                paramsDic["birthDate"] = utcTimeZoneStr
            }
        }
        else
        {
            paramsDic["birthDate"] = ""
        }
        
        User.updateContact(contact:self.contact, userDic:paramsDic, completionBlockSuccess: { (status: Bool) -> (Void) in
            
            DispatchQueue.global(qos: .background).async
            {
                DispatchQueue.main.async
                {
                    if status == true
                    {
                      ProcessingIndicator.hide()
                      
                      let alert = UIAlertController(title:"Success", message:"Contact updated sucessfully.", preferredStyle: UIAlertControllerStyle.alert)
            
                      alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                      
                      self.present(alert, animated: true, completion: nil)
                    }
                    else
                    {
                      ProcessingIndicator.hide()
                        
                      let alert = UIAlertController(title:"Error", message:"Some error occured, please try again later.", preferredStyle: UIAlertControllerStyle.alert)
                        
                      alert.addAction(UIAlertAction(title:"OK", style: UIAlertActionStyle.default, handler: nil))
                        
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

extension ContactDetailViewController
{
    @IBAction func startConversationButton_Tapped(_ sender: Any)
    {
        let storyboard = UIStoryboard.init(name: "ComposeMessage", bundle: nil)
        
        self.composeMessageViewController = (storyboard.instantiateViewController(withIdentifier: "ComposeMessageViewController") as! ComposeMessageViewController)
        
        self.composeMessageViewController.delegate  = self
        self.composeMessageViewController.mobileNumber = self.contact.phoneNumber ?? ""
        
        self.view.addSubview(self.composeMessageViewController.view)
    }
}

extension ContactDetailViewController: ComposeMessageProtocol
{
    func newMessageAdded()
    {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: HomeViewController.self) {
                self.navigationController!.popToViewController(controller, animated: false)
                break
            }
        }
        
        if let delegate = self.delegate
        {
            delegate.newMessageAdded()
        }
    }
}
