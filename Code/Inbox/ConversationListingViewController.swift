import UIKit

class ConversationListingViewController: UIViewController, ConversationListingTableCellProtocol
{
    @IBOutlet weak var counterLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var markAllAsRead_Btn: UIButton!

    var selectedConversation:Conversation! = nil

    var tableViewDataSource:InboxTableViewDataSource? = nil
    
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
    
    func conversationSelected(conversation:Conversation) -> Bool {
        
        self.currentConversation = conversation
        /****************************************************************/
        self.messageFromLabel.text =  (currentConversation.firstName)! + " " + (currentConversation.lastName)!
        self.messageNumberLabel.text = conversation.mobile
        self.shortCodeLabel.text = conversation.shortcodeDisplay
        self.sendTextField.text = ""
        /****************************************************************/
        
        ProcessingIndicator.show()
        
        User.getMessageForConversation(self.currentConversation, completionBlockSuccess: {(messages:Array<Message>?) -> (Void) in
            
            
            DispatchQueue.global(qos:.background).async
                {
                    DispatchQueue.main.async
                        {
                            
                            if self.currentConversation.isRead == true {
                                
                                User.setReadConversation(conversation: self.currentConversation, completionBlockSuccess: { (status: Bool) -> (Void) in
                                    
                                    ProcessingIndicator.hide()
                                    if conversation.isRead == true {
                                        
                                        conversation.isRead = false
                                        self.inboxTableViewDataSource?.reloadControls()
                                        self.refreshUnReadCount()
                                        
                                        //            do {
                                        //
                                        //                try conversation.managedObjectContext?.save()
                                        //            }
                                        //            catch let error as NSError {
                                        //                print("Could not fetch \(error), \(error.userInfo)")
                                        //            }
                                        
                                    }
                                    
                                }, andFailureBlock: { (error:Error?) -> (Void) in
                                    ProcessingIndicator.hide()
                                    if conversation.isRead == true {
                                        
                                        conversation.isRead = false
                                        self.inboxTableViewDataSource?.reloadControls()
                                        self.refreshUnReadCount()
                                        
                                        //            do {
                                        //
                                        //                try conversation.managedObjectContext?.save()
                                        //            }
                                        //            catch let error as NSError {
                                        //                print("Could not fetch \(error), \(error.userInfo)")
                                        //            }
                                        
                                    }
                                    //Error
                                })
                            }
                            //                            if ((self.currentConversation.messages?.count)! > 0) {
                            ProcessingIndicator.hide()

                            _ = (self.messageTableViewDataSource?.loadConversation(conversation_: self.currentConversation))!
                            
                            //                            } else {
                            //clear previous messages
                            //                            }
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
    
    
    func refreshUnReadCount () {
        
        self.counterLabel.text = "(" + String(self.showUnReadConversationCount(User.getLoginedUser()?.conversations)) + ")"
        
    }
}

extension ConversationListingViewController
{
    func initiateMessageCall() {
        let dispatchTime = DispatchTime.now() + .seconds(30)
        
        DispatchQueue.main.asyncAfter(deadline: dispatchTime)
        {
            
            if self.isShowActivityIndicator == true{
                ProcessingIndicator.show()
            }
            self.getConversationUpdate()
        }
    }
    
    func getConversationUpdate() {
        
        if self.isShowActivityIndicator == true{
            ProcessingIndicator.show()
        }
        
        User.getLatestConversations(completionBlockSuccess: {(conversations:Array<Conversation>?) -> (Void) in
            
            DispatchQueue.global(qos:.background).async
                {
                    DispatchQueue.main.async
                        {
                            
                            if self.isShowActivityIndicator == true{
                                ProcessingIndicator.hide()
                                self.isShowActivityIndicator = false
                            }
                            self.inboxTableViewDataSource?.reloadControls()
                            
                            self.refreshUnReadCount()
                            
                            let dispatchTime = DispatchTime.now() + .seconds(30)
                            
                            DispatchQueue.main.asyncAfter(deadline: dispatchTime)
                            {
                                self.getConversationUpdate()
                            }
                    }
            }
            
        }) {(error:Error?) -> (Void) in
            
            DispatchQueue.global(qos:.background).async
                {
                    DispatchQueue.main.async
                        {
                            if self.isShowActivityIndicator == true{
                                ProcessingIndicator.hide()
                                self.isShowActivityIndicator = false
                            }
                            
                            self.getConversationUpdate()
                    }
            }
        }
    }
    
    func sendMessageToConversation(conversation: Conversation, message: String) -> Bool {
        
        User.sendUserMessage(conversation: conversation, message: message, completionBlockSuccess: { (sendMessaage:Message) -> (Void) in
            
            DispatchQueue.global(qos:.background).async
                {
                    DispatchQueue.main.async
                        {
                            ProcessingIndicator.hide()
                            self.sendTextField.text = ""
                            _ = self.messageTableViewDataSource?.reloadControls() //addNewMessage(sendMessaage)
                    }
            }
            
        }) { (error:Error?) -> (Void) in
            DispatchQueue.global(qos:.background).async
                {
                    DispatchQueue.main.async
                        {
                            ProcessingIndicator.hide()
                            
                            self.sendTextField.text = ""
                            
                            let alert = UIAlertController(title: "Error", message: error?.localizedDescription , preferredStyle: UIAlertControllerStyle.alert)
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
    func applySearchFiltersForSearchText(_ text:String)
    {
        
    }
}
