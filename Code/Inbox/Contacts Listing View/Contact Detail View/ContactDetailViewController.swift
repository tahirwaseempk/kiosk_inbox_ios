import UIKit
import Foundation

class ContactDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    let headerColor = UIColor.init(displayP3Red:0.96, green:0.97, blue:1.0, alpha:1.0)

    var contact:UserContact!
    
    var createTageView: CreateTagView!
    
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var headerContactNumberLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveDetailButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.setupControls()
    }
    
    func setupControls()
    {
        self.createTageView = CreateTagView.instanceFromNib(delegate:self)
                    
        self.loadData()
    }
    
    func loadData()
    {
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
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func createTagButton_Tapped(_ sender: Any)
    {
        self.createTageView.frame = self.view.bounds
        
        self.view.addSubview(self.createTageView)
    }
    
    @IBAction func deleteTagButton_Tapped(_ sender: Any)
    {
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to delete this contact ", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in

            
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

        self.present(alert, animated: true)
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
        if indexPath.section == 0
        {
            let cell:ContactNameTableViewCell = tableView.dequeueReusableCell(withIdentifier:"ContactsListTableViewCell", for:indexPath) as! ContactNameTableViewCell
            
            if indexPath.row == 0
            {
                cell.headerLbl.text = "First Name"
                
                cell.titleLbl.text = self.contact.firstName
            }
            else if indexPath.row == 1
            {
                cell.headerLbl.text = "Last Name"
                
                cell.titleLbl.text = self.contact.lastName
            }
            else if indexPath.row == 2
            {
                cell.headerLbl.text = "Email"
                
                cell.titleLbl.text = self.contact.email
            }
            else if indexPath.row == 3
            {
                cell.headerLbl.text = "Date Of Birth"
                
                let dateFormatter =  DateFormatter()
                
                dateFormatter.dateFormat = DOB_FORMATE
                
                let birthDate = dateFormatter.string(from:self.contact.birthDate!)

                cell.titleLbl.text = birthDate
            }
            else if indexPath.row == 4
            {
                cell.headerLbl.text = "Gender"
                
                cell.titleLbl.text = self.contact.gender
            }

            return cell
        }
        else if indexPath.section == 1
        {
            let cell:ContactNameTableViewCell =  tableView.dequeueReusableCell(withIdentifier:"ContactsListTableViewCell", for:indexPath) as! ContactNameTableViewCell
            
            if indexPath.row == 0
            {
                cell.headerLbl.text = "Address"
                
                cell.titleLbl.text = self.contact.address
            }
            else if indexPath.row == 1
            {
                cell.headerLbl.text = "State"
                
                cell.titleLbl.text = self.contact.country
            }
            else if indexPath.row == 2
            {
                cell.headerLbl.text = "ZipCode"
                
                cell.titleLbl.text = self.contact.zipCode
            }
            
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
    
    func deleteTagTapped(_ tagToDelete:String)
    {
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to delete the tag: " + tagToDelete, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in

            
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }
}

