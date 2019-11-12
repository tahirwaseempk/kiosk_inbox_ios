import UIKit
import Foundation

protocol ContactDetailViewControllerDelegate
{
    func deleteContactsFromLocalArrays(contactsToRemove:Array<UserContact>)
}

class ContactsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    let headerColor = UIColor.init(displayP3Red:0.96, green:0.97, blue:1.0, alpha:1.0)

    let alphabets = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","#"]
    
    var filteredContacts = Dictionary<String,Array<UserContact>>()
    var selectedItems = Set<UserContact>()
    var isSelectionModeOn = false
    var createTageView: CreateTagView!
    var currentNavigationController:UINavigationController!
    var delegate:ContactListViewControllerDelegate?
    
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var menuContainerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectAllButton: UIButton!
    @IBOutlet weak var saerchBar: UISearchBar!
    @IBOutlet weak var bottomViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomViewContainer: UIView!
    @IBOutlet weak var menuAddButton: UIButton!
    
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
        
        self.fetchData()
        
        self.createTageView = CreateTagView.instanceFromNib(delegate:self)
        
        self.addGesture()
        
        self.disableBottomView()
    }
    
    func fetchData()
    {
        if let contactsList = User.loginedUser?.userContacts?.allObjects as? Array<UserContact>
        {
            loadDataFromList(contactsList:contactsList)
        }
    }
    
    func loadDataFromList(contactsList:Array<UserContact>)
    {
        //let alphabetical = Dictionary(grouping: contactsList) { $0.((contact.firstName ?? "") + (contact.lastName ?? "")).first! }
     
        self.filteredContacts.removeAll()
        
        for contact in contactsList
        {
            let name = (contact.firstName ?? "") + (contact.lastName ?? "")
            
            var firstCharacterStr = ""
            
            if let firstCharacter = name.first
            {
                firstCharacterStr = String(firstCharacter).uppercased()
            }
            else
            {
                firstCharacterStr = "#"
            }
            
            if firstCharacterStr == "" || firstCharacterStr == " " || alphabets.contains(firstCharacterStr) == false
            {
                firstCharacterStr = "#"
            }
            
            if var arrayOfSameNameContacts = self.filteredContacts[firstCharacterStr]
            {
                arrayOfSameNameContacts.append(contact)
                
                self.filteredContacts[firstCharacterStr] = arrayOfSameNameContacts
            }
            else
            {
                var arrayOfSameNameContacts = Array<UserContact>()
                
                arrayOfSameNameContacts.append(contact)
                
                self.filteredContacts[firstCharacterStr] = arrayOfSameNameContacts
            }
        }
        
        self.tableView.reloadData()
    }
    
    func cornerRadius()
    {
        //self.createTagAlertView.layer.cornerRadius = 5.0
    }
    
    func updateBottomView()
    {
        if self.isSelectionModeOn == true
        {
            self.enableBottomView()
        }
        else
        {
            self.disableBottomView()
        }
    }
    
    func enableBottomView()
    {
        self.menuAddButton.setTitle("X", for:.normal)
        
        self.bottomViewHeightConstraint.constant = 60
        
        self.bottomViewContainer.isHidden = false
    }
    
    func disableBottomView()
    {
        self.menuAddButton.setTitle("+", for:.normal)

        self.bottomViewHeightConstraint.constant = 0
        
        self.bottomViewContainer.isHidden = true
    }
    
    @IBAction func backButtonTapped(_ sender: Any)
    {
        self.resignAllControls()

        self.view.removeFromSuperview()
    }
    
    @IBAction func uploadContacts_Tapped(_ sender: Any)
    {
        let viewController:UIViewController = UIStoryboard(name:"Contacts", bundle: nil).instantiateViewController(withIdentifier:"UploadContactViewController") as! UploadContactViewController
        
        self.currentNavigationController.pushViewController(viewController, animated:true)
        
        self.menuContainerView.isHidden = true
    }
    
    @IBAction func dismissMenu_Tapped(_ sender: Any)
    {
        self.menuContainerView.isHidden = true
    }
    
    @IBAction func menuOptionButton_Tapped(_ sender:UIButton)
    {
        if self.isSelectionModeOn == true
        {
            self.resignAllControls()

            selectedItems.removeAll()
                                                          
            self.isSelectionModeOn = false
                               
            self.tableView.reloadData()
                               
            self.updateBottomView()
        }
        else
        {
            self.resignAllControls()

            self.menuContainerView.isHidden = false
        }
    }
    
    @IBAction func createTagButton_Tapped(_ sender: Any)
    {
        self.resignAllControls()

        self.createTageView.frame = self.view.bounds
        
        self.createTageView.contacts = Array(self.selectedItems)
        
        self.view.addSubview(self.createTageView)
    }
        
    @IBAction func selectAllButton_Tapped(_ sender:UIButton)
    {
        self.resignAllControls()

        if sender.isSelected == true
        {
            selectedItems.removeAll()
        }
        else
        {
            for (_,contacts) in self.filteredContacts
            {
                for contact in contacts
                {
                    self.selectedItems.insert(contact)
                }
            }
        }
        
        sender.isSelected = !sender.isSelected
        
        self.tableView.reloadData()
    }
    
    func addGesture()
    {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action:#selector(self.longPress))
        
        self.tableView.addGestureRecognizer(longPressRecognizer)
    }
    
    @objc func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer)
    {
        if isSelectionModeOn == false
        {
            if longPressGestureRecognizer.state == UIGestureRecognizer.State.began
            {
                let touchPoint = longPressGestureRecognizer.location(in: self.tableView)
                
                if let indexPath = tableView.indexPathForRow(at: touchPoint)
                {
                    self.resignAllControls()

                    selectedItems.removeAll()
                    
                    if let contact = self.getContactAtIndex(row:indexPath.row, section:indexPath.section)
                    {
                        selectedItems.insert(contact)
                    }
                    
                    self.isSelectionModeOn = true
                    
                    self.tableView.reloadData()
                    
                    self.updateBottomView()
                }
            }
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int
    {
        if let sortedKeys = self.filteredContacts.allKeysSortedAlphabetically()
        {
            return sortedKeys.count
        }
        
        return 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let sortedKeys = self.filteredContacts.allKeysSortedAlphabetically()
        {
            if let cotactsArray = self.filteredContacts[sortedKeys[section]]
            {
                return cotactsArray.count
            }
        }
        
        return 0
    }
        
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let header = UIView.init(frame:CGRect(x:0, y:0, width:tableView.bounds.size.width, height:30.0))
        
        header.backgroundColor = headerColor
        
        let titleLabel = UILabel.init(frame:CGRect(x:20, y:0, width:header.bounds.size.width, height:header.bounds.size.height))
        
        titleLabel.font = UIFont.boldSystemFont(ofSize:17.0)
        
        if let sortedKeys = self.filteredContacts.allKeysSortedAlphabetically()
        {
            titleLabel.text = sortedKeys[section]
        }
        else
        {
            titleLabel.text = ""
        }
                
        header.addSubview(titleLabel)
        
        return header
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]?
    {
        if let sortedKeys = self.filteredContacts.allKeysSortedAlphabetically()
        {
            return sortedKeys
        }
        
        return Array<String>()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:ContactsListTableViewCell = tableView.dequeueReusableCell(withIdentifier:"ContactsListTableViewCell") as! ContactsListTableViewCell

        if let contact = self.getContactAtIndex(row:indexPath.row, section:indexPath.section)
        {
            cell.loadCell(chatModel:contact)
            
            cell.selectionImageView?.isHighlighted = self.selectedItems.contains(contact)
        }
        else
        {
            cell.reset()
        }
        
        cell.selectionImageView?.isHidden = !self.isSelectionModeOn

        cell.titleLeadingConstraintWithImage.isActive = self.isSelectionModeOn
        
        cell.titleLeadingConstraintWithSuperView.isActive = !self.isSelectionModeOn

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if self.isSelectionModeOn == true
        {
            if let contact = self.getContactAtIndex(row:indexPath.row, section:indexPath.section)
            {
                if self.selectedItems.contains(contact)
                {
                    self.selectedItems.remove(contact)
                }
                else
                {
                    self.selectedItems.insert(contact)
                }
            }
            
            self.tableView.reloadData()
        }
        else
        {
            if let contact = self.getContactAtIndex(row:indexPath.row, section:indexPath.section)
            {
                let viewController:ContactDetailViewController = UIStoryboard(name:"Contacts", bundle: nil).instantiateViewController(withIdentifier:"ContactDetailViewController") as! ContactDetailViewController

                viewController.contact = contact
                
                viewController.delegate = self

                self.currentNavigationController.pushViewController(viewController, animated:true)
            }
        }
    }
}

extension ContactsListViewController
{
    func getContactAtIndex(row:Int, section:Int) -> UserContact?
    {
        if let sortedKeys = self.filteredContacts.allKeysSortedAlphabetically()
        {
            if let cotactsArray = self.filteredContacts[sortedKeys[section]]
            {
                return cotactsArray[row]
            }
        }
        
        return nil
    }
}

extension ContactsListViewController:CreateTagViewDelegate
{
    func tagCreated()
    {
        self.tableView.reloadData()
    }
}

extension ContactsListViewController:UISearchBarDelegate
{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        searchBar.showsCancelButton = false
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar)
    {
        searchBar.showsCancelButton = false
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.text = ""
        
        self.resignAllControls()
        
        self.searchBar(searchBar, textDidChange:searchBar.text ?? "")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        self.resignAllControls()
        
        self.searchBar(searchBar, textDidChange:searchBar.text ?? "")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        searchBar.showsCancelButton = true
        
        if searchText.count < 1
        {
            if let contactsList = User.loginedUser?.userContacts?.allObjects as? Array<UserContact>
            {
                loadDataFromList(contactsList:contactsList)
            }
            else
            {
                loadDataFromList(contactsList:Array<UserContact>())
            }
        }
        else
        {
            if let contactsList = User.loginedUser?.userContacts?.allObjects as? Array<UserContact>
            {
                let contacts_filtered_local = contactsList.filter({ (contact) -> Bool in
                                        
                    if let firstName = contact.firstName
                    {
                        if let lastName = contact.lastName
                        {
                            return (firstName + " " + lastName).lowercased().contains(searchText.lowercased())
                        }
                        else
                        {
                            return firstName.lowercased().contains(searchText.lowercased())
                        }
                    }
                    else if let lastName = contact.lastName
                    {
                        return lastName.lowercased().contains(searchText.lowercased())
                    }
                    
                    return false
                })
                
                loadDataFromList(contactsList:contacts_filtered_local)
            }
            else
            {
                loadDataFromList(contactsList:Array<UserContact>())
            }
        }
        
        self.tableView.reloadData()
    }
    
    func resignAllControls()
    {
        self.saerchBar.resignFirstResponder()
        
        tableView.resignFirstResponder()
        
        self.saerchBar.showsCancelButton = false
    }
}

extension ContactsListViewController: ContactDetailViewControllerDelegate
{
    @IBAction func deleteTagButton_Tapped(_ sender: Any)
    {
        if self.selectedItems.count > 0
        {
            let alert = UIAlertController(title: "Alert", message: "Are you sure you want to delete these contact ", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                
                self.deleteContacts()
            }))
            
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

            self.present(alert, animated: true)
        }
        else
        {
            let alert = UIAlertController(title: "Alert", message: "Selected atleast one contact to delete", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

            self.present(alert, animated: true)
        }
    }
    
    func deleteContacts()
    {
        ProcessingIndicator.show()

        self.resignAllControls()
        
        UserContact.deleteContacts(contacts:Array(self.selectedItems), completionBlockSuccess: { (status:Bool) -> (Void) in
            DispatchQueue.global(qos: .background).async
            {
                DispatchQueue.main.async
                {
                    self.deleteContactsFromLocalArrays(contactsToRemove:Array(self.selectedItems))

                    ProcessingIndicator.hide()
                       
                    let alert = UIAlertController(title:"Contacts Deleted ",message:"Selected contacts delted successfully",preferredStyle: UIAlertControllerStyle.alert)
                       
                    let okAction = UIAlertAction(title:"OK", style:.default) { (action:UIAlertAction) in
                           
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
    
    func deleteContactsFromLocalArrays(contactsToRemove:Array<UserContact>)
    {
        if let delegate = self.delegate
        {
            delegate.contactsDeleted(contactsToRemove: contactsToRemove)
        }
        
        for contact in contactsToRemove
        {
            self.selectedItems.remove(contact)
        }
        
        self.resignAllControls()

        selectedItems.removeAll()
                                                      
        self.isSelectionModeOn = false
                                                      
        self.updateBottomView()
        
        self.saerchBar.text = nil
        
        if let contactsList = User.loginedUser?.userContacts?.allObjects as? Array<UserContact>
        {
            loadDataFromList(contactsList:contactsList)
        }
        else
        {
            loadDataFromList(contactsList:Array<UserContact>())
        }
    }
}

extension ContactsListViewController
{
    @IBAction func navBarTagButtonTapped(_ sender:UIButton)
    {
        self.applyTagFilter()
    }
    
    func applyTagFilter()
    {
        
    }
}

