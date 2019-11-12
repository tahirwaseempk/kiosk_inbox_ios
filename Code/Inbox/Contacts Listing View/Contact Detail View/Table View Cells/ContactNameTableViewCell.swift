import UIKit
import SwiftyPickerPopover

enum CellType:NSInteger
{
    case FirstNameField
    case LastNameField
    case EmailField
    case DOBField
    case GenderField
    case AddressField
    case StateField
    case ZipCodeField
}

protocol ContactNameTableViewCellDelegate
{
    func updatedFirstNameField(_ newValue:String)
    
    func updatedLastNameField(_ newValue:String)
    
    func updatedEmailField(_ newValue:String)
    
    func updatedDOBField(_ newValue:Date)
    
    func updatedGenderField(_ newValue:String)
    
    func updatedAddressField(_ newValue:String)
    
    func updatedStateField(_ newValue:String)
    
    func updatedZipCodeField(_ newValue:String)
}

class ContactNameTableViewCell: UITableViewCell, UITextFieldDelegate
{
    @IBOutlet weak var titleTxtField: UITextField!
    @IBOutlet weak var headerLbl: UILabel!
    
    var cellType:CellType!
    var delegate:ContactNameTableViewCellDelegate!
    var DOBValue:Date?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    func loadCell(FirstNameValue:String, LastNameValue:String, EmailValue:String, DOBValue:Date?, GenderValue:String, AddressValue:String, StateValue:String, ZipCodeValue:String, indexPath:IndexPath, delegate:ContactNameTableViewCellDelegate)
    {
        self.delegate = delegate
        
        self.titleTxtField.delegate = self
        
        self.DOBValue = DOBValue

        if indexPath.section == 0
        {
            if indexPath.row == 0
            {
                self.headerLbl.text = "First Name"
                
                self.titleTxtField.text = FirstNameValue
                
                self.cellType = .FirstNameField
            }
            else if indexPath.row == 1
            {
                self.headerLbl.text = "Last Name"
                
                self.titleTxtField.text = LastNameValue
                
                self.cellType = .LastNameField
            }
            else if indexPath.row == 2
            {
                self.headerLbl.text = "Email"
                
                self.titleTxtField.text = EmailValue
                
                self.cellType = .EmailField
            }
            else if indexPath.row == 3
            {
                self.headerLbl.text = "Date Of Birth"
                
                if let DOBValue = self.DOBValue
                {
                    let dateFormatter =  DateFormatter()
                    
                    dateFormatter.dateFormat = DOB_FORMATE
                    
                    let outStr = dateFormatter.string(from:DOBValue)
                    
                    if (outStr == "07/10/68000")
                    {
                        self.titleTxtField.text = ""
                    }
                    else
                    {
                        self.titleTxtField.text = outStr
                    }
                }
                else
                {
                    self.titleTxtField.text = ""
                }
                
                self.cellType = .DOBField
            }
            else if indexPath.row == 4
            {
                self.headerLbl.text = "Gender"
                
                self.titleTxtField.text = GenderValue
                
                self.cellType = .GenderField
            }
        }
        else if indexPath.section == 1
        {
            if indexPath.row == 0
            {
                self.headerLbl.text = "Address"
                
                self.titleTxtField.text = AddressValue
                
                self.cellType = .AddressField
            }
            else if indexPath.row == 1
            {
                self.headerLbl.text = "State"
                
                self.titleTxtField.text = StateValue
                
                self.cellType = .StateField
            }
            else if indexPath.row == 2
            {
                self.headerLbl.text = "ZipCode"
                
                self.titleTxtField.text = ZipCodeValue
                
                self.cellType = .ZipCodeField
            }
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if self.cellType == .DOBField
        {
            self.loadDatePickerFromTextField(textField)
            
            return false
        }
        else if self.cellType == .GenderField
        {
            self.loadGenderPickerFromTextField(textField)
            
            return false
        }
        else if self.cellType == .StateField
        {
            self.loadCountryPickerFromTextField(textField)
            
            return false
        }
        
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if self.cellType == .FirstNameField
        {
            delegate.updatedFirstNameField(textField.text ?? "")
        }
        else if self.cellType == .LastNameField
        {
            delegate.updatedLastNameField(textField.text ?? "")
        }
        else if self.cellType == .EmailField
        {
            delegate.updatedEmailField(textField.text ?? "")
        }
        else if self.cellType == .DOBField
        {
            
        }
        else if self.cellType == .GenderField
        {
            
        }
        else if self.cellType == .AddressField
        {
            delegate.updatedAddressField(textField.text ?? "")
        }
        else if self.cellType == .StateField
        {
            
        }
        else if self.cellType == .ZipCodeField
        {
            delegate.updatedZipCodeField(textField.text ?? "")
        }
    }
    
    func loadDatePickerFromTextField(_ textField:UITextField)
    {
        let picker = DatePickerPopover(title: "")
            
         _ = picker.setDateMode(.date)
        
         _ = picker.setDoneButton(action: { (popOver, selectDate) in

            self.DOBValue = selectDate
            
            self.delegate.updatedDOBField(selectDate)
         })
        
         _ = picker.setCancelButton(action: { _, _ in print("cancel")})
        
         _ = picker.setSelectedDate(self.DOBValue ?? Date())

         picker.appear(originView:textField, baseViewController:(self.delegate as! UIViewController))
    }
         
     func loadGenderPickerFromTextField(_ textField:UITextField)
     {
        var selectedIndex = 0
        
        if self.titleTxtField.text == "F"
        {
            selectedIndex = 1
        }
        
        let picker = StringPickerPopover(title: "Select Gender", choices: ["M","F"])
             
        _ = picker.setValueChange(action: { _, _, selectedString in })
             
        _ = picker.setDoneButton(action: { popover, selectedRow, selectedString in
                    
            self.delegate.updatedGenderField(selectedString)
        })
             
        _ = picker.setCancelButton(action: {_, _, _ in })
             
        _ = picker.setSelectedRow(selectedIndex)
                
        picker.appear(originView:textField, baseViewController:(self.delegate as! UIViewController))
     }
         
     func loadCountryPickerFromTextField(_ textField:UITextField)
     {
         let picker = StringPickerPopover(title:"Select State", choices:States)
             
        _ = picker.setValueChange(action: { _, _, selectedString in })
             
        _ = picker.setDoneButton(action: { popover, selectedRow, selectedString in
                    
            self.delegate.updatedStateField(selectedString)
        })
            
        _ = picker.setCancelButton(action: {_, _, _ in})
        
        picker.appear(originView:textField, baseViewController:(self.delegate as! UIViewController))
     }
}

