import UIKit

class SearchView: UITableViewHeaderFooterView
{
    @IBOutlet weak var searchBar: UISearchBar!
    
    var delegate : SearchViewProtocol? = nil
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.setupControls()
    }
    
    func setupControls()
    {
        self.setupSearchbar()
    }
}

extension SearchView:UISearchBarDelegate
{
    func setupSearchbar()
    {
        self.searchBar.delegate = self
        
        self.searchBar.enablesReturnKeyAutomatically = false
        
        self.searchBar.returnKeyType = .done

        self.searchBar.searchBarStyle = UISearchBarStyle.prominent
        self.searchBar.isTranslucent = false
        
        self.searchBar.barTintColor = AppThemeColor

//        switch environment {
//        case .texting_Line:
//            self.searchBar.barTintColor = AppThemeColor
//        case .sms_Factory:
//            self.searchBar.barTintColor = AppThemeColor//UIColor(red: 74/255.0, green: 146/255.0, blue: 226/255.0, alpha: 1.0)
//        case .fan_Connect:
//            self.searchBar.barTintColor = AppThemeColor//UIColor(red: 74/255.0, green: 146/255.0, blue: 226/255.0, alpha: 1.0)
//        case .photo_Texting:
//            self.searchBar.barTintColor = AppThemeColor//UIColor(red: 74/255.0, green: 146/255.0, blue: 226/255.0, alpha: 1.0)
//        }
     }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar)
    {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar,textDidChange searchText: String)
    {
        if let delegate = self.delegate
        {
            delegate.applySearchFiltersForSearchText(searchText)
        }
    }
}
