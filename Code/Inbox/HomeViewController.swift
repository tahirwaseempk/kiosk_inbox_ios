import UIKit

class HomeViewController: UIViewController
{
    @IBOutlet weak var signOutButton: UIButton!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var conversationListingContainer: UIView!
    
    @IBOutlet weak var conversationDetailContainer: UIView!
    
    @IBOutlet weak var header_View: UIView!
    
    @IBOutlet weak var compose_Button: UIButton!
    
    var composeMessageViewController:ComposeMessageViewController!
    
    var conversationListingViewController:ConversationListingViewController!
    
    var conversationDetailViewController:ConversationDetailViewController!
    
    var selectedConversation:Conversation? = nil
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        switch environment {
        case .texting_Line:
            header_View.backgroundColor = AppBlueColor
            searchBar.backgroundColor = AppBlueColor
//            compose_Button.backgroundColor = AppBlueColor
//            compose_Button.setImage(UIImage(named: "compose_blue")?.withRenderingMode(.alwaysTemplate), for: UIControlState.normal)
//            loginButton.setTitleColor(UIColor.white, for: UIControlState.normal)
            compose_Button.setImage(UIImage(named: "compose_blue"), for: UIControlState.normal)
        case .sms_Factory:
            header_View.backgroundColor = AppBlueColor
            searchBar.backgroundColor = AppBlueColor
//            compose_Button.backgroundColor = AppBlueColor
//            compose_Button.setImage(UIImage(named: "compose_blue")?.withRenderingMode(.alwaysTemplate), for: UIControlState.normal)
            compose_Button.setImage(UIImage(named: "compose_blue"), for: UIControlState.normal)

        case .fan_Connect:
            header_View.backgroundColor = FanAppColor
            searchBar.backgroundColor = FanAppColor
//            compose_Button.backgroundColor = FanAppColor
//            compose_Button.setImage(UIImage(named: "compose_green")?.withRenderingMode(.alwaysTemplate), for: UIControlState.normal)
            compose_Button.setImage(UIImage(named: "compose_green"), for: UIControlState.normal)

        case .photo_Texting:
            header_View.backgroundColor = PhotoAppColor
            searchBar.backgroundColor = PhotoAppColor
//            compose_Button.setImage(UIImage(named: "compose_purple")?.withRenderingMode(.alwaysTemplate), for: UIControlState.normal)
//            compose_Button.tintColor = PhotoAppColor
//            compose_Button.backgroundColor = UIColor.white
            compose_Button.setImage(UIImage(named: "compose_purple"), for: UIControlState.normal)
        }
        
        self.setupControls()
    }
    
    func setupControls()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.pushNotificationRecieved), name: PushNotificationName, object: nil)
        
        
        self.setupSignoutButton()
        
        self.setupSearchbar()
        
        self.setupConversationListingView()
        
        self.setupConversationDetailView()
        
        self.refreshUnReadCount()
    }
    
    @objc func pushNotificationRecieved()
    {
        UIApplication.shared.applicationIconBadgeNumber = 0
        self.conversationListingViewController.callLastConversationsUpdate()
    }
    
    func setupSignoutButton()
    {
        
    }
    
    func setupConversationListingView()
    {
        let storyboard = UIStoryboard.init(name: "ConversationListing", bundle: nil)
        
        self.conversationListingViewController = storyboard.instantiateViewController(withIdentifier: "ConversationListingViewController") as! ConversationListingViewController
        
        self.conversationListingViewController.delegate = self
        
        self.conversationListingContainer.addSubview(self.conversationListingViewController.view)
        
        self.conversationListingViewController.view.frame = self.conversationListingContainer.bounds
        
        self.addChildViewController(self.conversationListingViewController)
    }
    
    func setupConversationDetailView()
    {
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            let storyboard = UIStoryboard.init(name: "ConversationDetail", bundle: nil)
            
            self.conversationDetailViewController = storyboard.instantiateViewController(withIdentifier: "ConversationDetailViewController") as! ConversationDetailViewController
            
            self.conversationDetailViewController.delegate = self
            
            self.conversationDetailContainer.addSubview(self.conversationDetailViewController.view)
            
            self.conversationDetailViewController.view.frame = self.conversationDetailContainer.bounds
        }
    }
    
    @IBAction func signOut_Tapped(_ sender: Any)
    {
        NotificationCenter.default.removeObserver(self, name: PushNotificationName, object: nil)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func createMessage_Tapped(_ sender: Any)
    {
        let storyboard = UIStoryboard.init(name: "ComposeMessage", bundle: nil)
        
        self.composeMessageViewController = storyboard.instantiateViewController(withIdentifier: "ComposeMessageViewController") as! ComposeMessageViewController
        
        self.composeMessageViewController.delegate  = self
        
        self.view.addSubview(self.composeMessageViewController.view)
    }
    
    @IBAction func refreshButton_Tapped(_ sender: Any)
    {
        self.conversationListingViewController.callLastConversationsUpdate()
    }
    
    @IBAction func searchButton_Tapped(_ sender: Any)
    {
        UIView.animate(withDuration: 0.35)
        {
            self.searchBar.isHidden = !self.searchBar.isHidden
            
            if self.searchBar.isHidden == true
            {
                self.searchBar.resignFirstResponder()
                self.conversationListingViewController.applySearchFiltersForSearchText("")
            }
            else
            {
                self.searchBar.becomeFirstResponder()
            }
        }
    }
    
    func refreshUnReadCount ()
    {
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            self.userNameLabel.text = User.getLoginedUser()?.serial
        }
        else
        {
            self.userNameLabel.text = "Messages (" + String(self.showUnReadConversationCount(User.getLoginedUser()?.conversations)) + ")"
        }
    }
    
    func showUnReadConversationCount(_ conversations: NSSet?) -> Int
    {
        if conversations == nil
        {
            return 0
        }
        
        var arrConversations = conversations?.allObjects as! Array<Conversation>
        
        arrConversations = arrConversations.filter({ (conversation1) -> Bool in
            
            if (conversation1.isRead == true)
            {
                return true
            }
            else
            {
                return false
            }
        })
        
        return arrConversations.count
    }
    
}

extension HomeViewController:UISearchBarDelegate
{
    func setupSearchbar()
    {
        self.searchBar.delegate = self
        
        self.searchBar.enablesReturnKeyAutomatically = false
        
        self.searchBar.returnKeyType = .done
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
        
        self.searchBar.isHidden = true
    }
    
    func searchBar(_ searchBar: UISearchBar,textDidChange searchText: String)
    {
        self.conversationListingViewController.applySearchFiltersForSearchText(searchText)
    }
}

extension HomeViewController:ConversationListingViewControllerProtocol
{
    func conversationSelected(conversation:Conversation?) -> Bool
    {
        self.selectedConversation = conversation
        
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            _ = self.conversationDetailViewController.conversationSelected(conversation: self.selectedConversation)
        }
        else
        {
            if conversation != nil
            {
                let storyboard = UIStoryboard.init(name: "ConversationDetail", bundle: nil)
                
                self.conversationDetailViewController = storyboard.instantiateViewController(withIdentifier: "ConversationDetailViewController") as! ConversationDetailViewController
                
                self.conversationDetailViewController.delegate = self
                
                self.conversationDetailViewController.selectedConversation = conversation
                self.conversationListingViewController.navigationController?.pushViewController(self.conversationDetailViewController, animated: true)
            }
        }
        
        return true
    }
}

extension HomeViewController:ConversationDetailViewControllerProtocol
{
    func conversationRemoved()
    {
        self.conversationListingViewController.conversartionRemoved()
    }
}

extension HomeViewController: ComposeMessageProtocol
{
    func newMessageAdded()
    {
        self.conversationListingViewController.callLastConversationsUpdate()
    }
}
