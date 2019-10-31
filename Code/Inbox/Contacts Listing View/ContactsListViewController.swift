import UIKit
import Foundation

class ContactsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    let headerColor = UIColor.init(displayP3Red:0.96, green:0.97, blue:1.0, alpha:1.0)

    let alphabets = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","#"]
    
    var contacts = Array<UserContact>()
    var filteredContacts = Array<UserContact>()
    var selectedItems = Set<Int>()
    var isSelectionModeOn = false
    var createTageView: CreateTagView!
    var currentNavigationController:UINavigationController!
    
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
        self.filteredContacts = self.contacts
        
        self.createTageView = CreateTagView.instanceFromNib(delegate:self)
        
        self.addGesture()
        
        self.disableBottomView()
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
            self.navBarTagButtonTapped(sender)
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
        
        self.view.addSubview(self.createTageView)
    }
    
    @IBAction func deleteTagButton_Tapped(_ sender: Any)
    {
        self.resignAllControls()

    }
    
    @IBAction func navBarTagButtonTapped(_ sender:UIButton)
    {
        self.resignAllControls()

        selectedItems.removeAll()
                                                      
        self.isSelectionModeOn = false
                           
        self.tableView.reloadData()
                           
        self.updateBottomView()
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
            for i in 0 ..< self.contacts.count
            {
                selectedItems.insert(i)
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
                    
                    selectedItems.insert(indexPath.row)
                    
                    self.isSelectionModeOn = true
                    
                    self.tableView.reloadData()
                    
                    self.updateBottomView()
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.filteredContacts .count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 3
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
        
        titleLabel.text = alphabets[section]
        
        header.addSubview(titleLabel)
        
        return header
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]?
    {
        return alphabets
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:ContactsListTableViewCell = tableView.dequeueReusableCell(withIdentifier:"ContactsListTableViewCell") as! ContactsListTableViewCell

        let contact = self.filteredContacts[indexPath.row]
        
        cell.loadCell(chatModel:contact)

        cell.selectionImageView?.isHidden = !self.isSelectionModeOn
        
        cell.selectionImageView?.isHighlighted = self.selectedItems.contains(indexPath.row)

        cell.titleLeadingConstraintWithImage.isActive = self.isSelectionModeOn
        
        cell.titleLeadingConstraintWithSuperView.isActive = !self.isSelectionModeOn

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if self.isSelectionModeOn == true
        {
            if self.selectedItems.contains(indexPath.row)
            {
                self.selectedItems.remove(indexPath.row)
            }
            else
            {
                self.selectedItems.insert(indexPath.row)
            }
            
            self.tableView.reloadData()
        }
        else
        {
            let viewController:UIViewController = UIStoryboard(name:"Contacts", bundle: nil).instantiateViewController(withIdentifier:"ContactDetailViewController") as! ContactDetailViewController
            
            self.currentNavigationController.pushViewController(viewController, animated:true)
        }
    }
}

extension ContactsListViewController:CreateTagViewDelegate
{
    func applyTagButton_Tapped()
    {
        
    }
}

extension ContactsListViewController:UISearchBarDelegate
{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar)
    {
        
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
            self.filteredContacts = self.contacts
        }
        else
        {
            self.filteredContacts.removeAll()

            self.filteredContacts = self.contacts.filter({ (contact) -> Bool in
                
                if let name = contact.firstName
                {
                    return name.contains(searchText)
                }
                
                return false
            })
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
