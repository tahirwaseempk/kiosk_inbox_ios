import UIKit

class ConversationListingViewController: UIViewController, ConversationListingTableCellProtocol
{
    @IBOutlet weak var counterLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var markAllAsRead_Btn: UIButton!

    var selectedConversation:Conversation! = nil

    var tableViewDataSource:InboxTableViewDataSource? = nil
    
    let shouldShowSpinnyForAutoRefreshCall = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
 
        self.setupControls()
        
        self.refreshUnReadCount()
        
        initiateMessageCall()
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
        self.getConversationUpdate()
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
    
    func conversationSelected(conversation:Conversation) -> Bool
    {
        self.selectedConversation = conversation

        ProcessingIndicator.show()
        
        User.getMessageForConversation(self.selectedConversation, completionBlockSuccess: {(messages:Array<Message>?) -> (Void) in
            
            DispatchQueue.global(qos:.background).async
            {
                DispatchQueue.main.async
                {
                    if self.selectedConversation.isRead == true
                    {
                        User.setReadConversation(conversation: self.selectedConversation, completionBlockSuccess: { (status: Bool) -> (Void) in
                            
                            DispatchQueue.global(qos:.background).async
                            {
                                DispatchQueue.main.async
                                {
                                    ProcessingIndicator.hide()
                                    
                                    if conversation.isRead == true
                                    {
                                        conversation.isRead = false
                                        
                                        self.conversationListUpdated()
                                    }
                                }
                            }
                            
                        }, andFailureBlock: { (error:Error?) -> (Void) in
                            
                            DispatchQueue.global(qos:.background).async
                            {
                                DispatchQueue.main.async
                                {
                                    ProcessingIndicator.hide()
                                    
                                    if conversation.isRead == true
                                    {
                                        conversation.isRead = false
                                        
                                        self.conversationListUpdated()
                                    }
                                }
                            }
                        })
                    }
                }
            }
            
        }) {(error:Error?) -> (Void) in
            
            DispatchQueue.global(qos:.background).async
            {
                DispatchQueue.main.async
                {
                        ProcessingIndicator.hide()
                        
                        _ = (self.messageTableViewDataSource?.loadConversation(conversation_: self.currentConversation))!
                        
                        let alert = UIAlertController(title: "ERROR", message: "Could not load conversation.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
        return true
    }
}

extension ConversationListingViewController
{
    func refreshUnReadCount ()
    {
        self.counterLabel.text = "(" + String(self.showUnReadConversationCount(User.getLoginedUser()?.conversations)) + ")"
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

extension ConversationListingViewController
{
    func initiateMessageCall()
    {
        let dispatchTime = DispatchTime.now() + .seconds(30)
        
        DispatchQueue.main.asyncAfter(deadline: dispatchTime)
        {
            self.getConversationUpdate()
        }
    }
    
    func getConversationUpdate()
    {
        if self.shouldShowSpinnyForAutoRefreshCall == true
        {
            ProcessingIndicator.show()
        }
        
        User.getLatestConversations(completionBlockSuccess: {(conversations:Array<Conversation>?) -> (Void) in
            
            DispatchQueue.global(qos:.background).async
            {
                DispatchQueue.main.async
                {
                    self.conversationListUpdated()

                    ProcessingIndicator.hide()

                    self.initiateMessageCall()
                }
            }
            
        }) {(error:Error?) -> (Void) in
            
            DispatchQueue.global(qos:.background).async
            {
                DispatchQueue.main.async
                {
                    ProcessingIndicator.hide()

                    self.initiateMessageCall()
                }
            }
        }
    }
}

extension ConversationListingViewController
{
    func conversationListUpdated()
    {
        //self.inboxTableViewDataSource?.reloadControls()

        self.selectedConversationUpdated()
        
        self.refreshUnReadCount()
    }
    
    func selectedConversationUpdated()
    {
        //self.inboxTableViewDataSource?.reloadControls()
        
        self.refreshUnReadCount()
    }

    func applySearchFiltersForSearchText(_ text:String)
    {
        
    }
}
