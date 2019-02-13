import UIKit

class ConversationListingViewController: UIViewController, ConversationListingTableCellProtocol
{
    @IBOutlet weak var counterLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var markAllAsRead_Btn: UIButton!
    
    var selectedConversation:Conversation! = nil
    
    var tableViewDataSource:InboxTableViewDataSource? = nil
    
    var delegate:ConversationListingViewControllerProtocol? = nil
    
    @IBOutlet weak var header_View: UIView!
    
    @IBOutlet weak var nomessageImage: UIImageView!
    
    
    
    @objc func willEnterForeground() {
        
        if (self.isViewLoaded && (self.view!.window != nil))
        {
            callLastConversationsUpdate()
        }
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
        self.setupControls()
        
        self.refreshUnReadCount()
        
        ////////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////////
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshListingTable), for: .valueChanged)
        tableView.refreshControl = refreshControl
        ////////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////////
        header_View.backgroundColor = AppThemeColor
        /*
         switch environment {
         case .texting_Line:
         header_View.backgroundColor = AppThemeColor
         case .sms_Factory:
         header_View.backgroundColor = AppThemeColor
         case .fan_Connect:
         header_View.backgroundColor = AppThemeColor
         case .photo_Texting:
         header_View.backgroundColor = AppThemeColor
         }
         
         */
        self.initiateMessageCall()
    }
    
    @objc func refreshListingTable(refreshControl: UIRefreshControl) {
        
        self.callLastConversationsUpdate()
        //        self.initiateMessageCall()
        
        refreshControl.endRefreshing()
    }
    func setupControls()
    {
        self.setupTableView()
    }
    
    func setupTableView()
    {
        self.tableViewDataSource = InboxTableViewDataSource(tableview: tableView, conversation: (User.getLoginedUser()?.conversations)!, delegate_: self)
        
        self.tableView.dataSource = tableViewDataSource
        
        self.tableView.tableFooterView = UIView()
    }
    
    @IBAction func refresh_Tapped(_ sender: Any)
    {
        self.callLastConversationsUpdate()
        //        self.initiateMessageCall()
        
    }
    
    @IBAction func markAllRead_Tapped(_ sender: Any)
    {
        ProcessingIndicator.show()
        
        User.setReadAllConversations(conversations: (User.getLoginedUser()?.conversations)!, index: 0, completionBlockSuccess: { (status:Bool) -> (Void) in
            
            DispatchQueue.global(qos: .background).async
                {
                    DispatchQueue.main.async
                        {
                            self.tableViewDataSource?.reloadControls()
                            
                            self.refreshUnReadCount()
                            
                            ProcessingIndicator.hide()
                    }
            }
            
        }) { (error:Error?) -> (Void) in
            
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
        }
    }
    
    func conversationSelected(conversation:Conversation?) -> Bool
    {
        self.selectedConversation = conversation
        ProcessingIndicator.show()
        callMessagesWebService()
        return true
    }
    
    func callMessagesWebService () {
        
        User.getMessageForConversation(self.selectedConversation, completionBlockSuccess: {(messages:Array<Message>?) -> (Void) in
            
            //            DispatchQueue.global(qos:.background).async
            //                {
            //                    DispatchQueue.main.async
            //                        {
            if self.selectedConversation.unreadMessages == true
            {
                User.setReadConversation(conversation: self.selectedConversation, completionBlockSuccess: { (status: Bool) -> (Void) in
                    
                    DispatchQueue.global(qos:.background).async
                        {
                            DispatchQueue.main.async
                                {
                                    ProcessingIndicator.hide()
                                    
                                    if self.selectedConversation.unreadMessages == true
                                    {
                                        self.selectedConversation.unreadMessages = false
                                        self.conversationListUpdated()
                                    }
                                    
                                    self.selectedConversationUpdated()
                            }
                    }
                    
                }, andFailureBlock: { (error:Error?) -> (Void) in
                    
                    DispatchQueue.global(qos:.background).sync
                        {
                            DispatchQueue.main.sync
                                {
                                    ProcessingIndicator.hide()
                                    
                                    if self.selectedConversation.unreadMessages == true
                                    {
                                        self.selectedConversation.unreadMessages = false
                                        self.conversationListUpdated()
                                    }
                                    
                                    self.selectedConversationUpdated()
                            }
                    }
                })
            }
            else
            {
                ProcessingIndicator.hide()
                self.selectedConversationUpdated()
            }
            //                    }
            //            }
            
        }) {(error:Error?) -> (Void) in
            
            DispatchQueue.global(qos:.background).sync
                {
                    DispatchQueue.main.sync
                        {
                            ProcessingIndicator.hide()
                            
                            self.selectedConversation = nil
                            
                            self.selectedConversationUpdated()
                            
                            let alert = UIAlertController(title:"Error",message:error?.localizedDescription,preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                    }
            }
        }
    }
}

extension ConversationListingViewController
{
    func refreshUnReadCount ()
    {
        self.counterLabel.text = "-"
        self.counterLabel.text = "(\(self.showUnReadConversationCount(User.getLoginedUser()?.conversations)))"
    }
    
    func showUnReadConversationCount(_ conversations: NSSet?) -> Int
    {
        if conversations == nil
        {
            return 0
        }
        
        var arrConversations = conversations?.allObjects as! Array<Conversation>
        
        arrConversations = arrConversations.filter({ (conversation1) -> Bool in
            
            if (conversation1.unreadMessages == true)
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

extension ConversationListingViewController
{
    func initiateMessageCall()
    {
        // ProcessingIndicator.show()
        
        //        if (self.isViewLoaded && (self.view!.window != nil))
        //        {
        let dispatchTime = DispatchTime.now() + .seconds(30)
        
        DispatchQueue.main.asyncAfter(deadline: dispatchTime)
        {
            self.updateConversationOnTimer()
        }
        //        }
    }
    
    func updateConversationOnTimer()
    {
        ProcessingIndicator.show()
        
        User.syncContacts(completionBlockSuccess: { () -> (Void) in
            
            DispatchQueue.global(qos:.background).async
                {
                    DispatchQueue.main.async
                        {
                            //UIApplication.shared.applicationIconBadgeNumber = 0
                            //updateBadgeCount()
                            self.conversationListUpdated()
                            ProcessingIndicator.hide()
                            if (self.isViewLoaded && (self.view!.window != nil)) {
                                self.initiateMessageCall()
                            }
                    }
            }
            
        }) { (error:Error?) -> (Void) in
            DispatchQueue.global(qos:.background).async
                {
                    DispatchQueue.main.async
                        {
                            ProcessingIndicator.hide()
                            if (self.isViewLoaded && (self.view!.window != nil)) {
                                self.initiateMessageCall()
                            }
                    }
            }
        }
    }
    
    func callLastConversationsUpdate()
    {
        ProcessingIndicator.show()
        
        User.syncContacts(completionBlockSuccess: { () -> (Void) in
            
            DispatchQueue.global(qos:.background).async
                {
                    DispatchQueue.main.async
                        {
                            // UIApplication.shared.applicationIconBadgeNumber = 0
                            updateBadgeCount()
                            self.conversationListUpdated()
                            ProcessingIndicator.hide()
                    }
            }
            
        }) { (error:Error?) -> (Void) in
            
            DispatchQueue.global(qos:.background).async
                {
                    DispatchQueue.main.async
                        {
                            ProcessingIndicator.hide()
                    }
            }            
        }
    }
    
}

extension ConversationListingViewController
{
    func conversationListUpdated()
    {
        if (User.getLoginedUser()?.conversations)!.count > 0
        {
            self.nomessageImage.isHidden = true
        }
        else
        {
            self.nomessageImage.isHidden = false
        }
        
        if self.tableViewDataSource?.searchView != nil
        {
            self.tableViewDataSource?.applySearchFiltersForSearchText((self.tableViewDataSource?.searchView.searchBar.text)!)
        }
        else
        {
            self.tableViewDataSource?.applySearchFiltersForSearchText("")
        }
        
        self.refreshUnReadCount()
        
        if let delegate = self.delegate
        {
            _ = delegate.updateConversationCount(str:"updateConversationCount")
        }
    }
    
    func selectedConversationUpdated()
    {
        self.conversationListUpdated()
        
        if let delegate = self.delegate
        {
            _ = delegate.conversationSelected(conversation: self.selectedConversation)
        }
    }
    
    func conversartionRemoved()
    {
        //BLOCK TO GET THE CONVERSATIONS AGAIN
        User.getLatestConversations(completionBlockSuccess: {(conversations:Array<Conversation>?) -> (Void) in
            
            DispatchQueue.global(qos:.background).async
                {
                    DispatchQueue.main.async
                        {
                            self.conversationListUpdated()
                            self.tableViewDataSource?.loadAfterRemoveConversation()
                            self.refreshUnReadCount()
                            
                            self.selectedConversation = nil
                            
                            if let delegate = self.delegate
                            {
                                _ = delegate.conversationSelected(conversation: self.selectedConversation)
                            }
                            if let delegate = self.delegate
                            {
                                _ = delegate.updateConversationCount(str:"updateConversationCount")
                            }
                            
                            ProcessingIndicator.hide()
                    }
            }
            
        }) {(error:Error?) -> (Void) in
            
            DispatchQueue.global(qos:.background).async
                {
                    DispatchQueue.main.async
                        {
                            self.tableViewDataSource?.loadAfterRemoveConversation()
                            
                            self.refreshUnReadCount()
                            
                            if let delegate = self.delegate
                            {
                                _ = delegate.updateConversationCount(str:"updateConversationCount")
                            }
                            ProcessingIndicator.hide()
                    }
            }
        }
    }
    
    func applySearchFiltersForSearchText(_ text:String)
    {
        self.tableViewDataSource?.applySearchFiltersForSearchText(text)
        self.refreshUnReadCount()
        if let delegate = self.delegate
        {
            _ = delegate.updateConversationCount(str:"updateConversationCount")
        }
    }
}
