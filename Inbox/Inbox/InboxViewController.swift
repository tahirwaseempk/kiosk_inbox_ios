//
//  InboxViewController.swift
//  Inbox
//
//  Created by Amir Akram on 21/06/2017.
//  Copyright © 2017 Amir Akram. All rights reserved.
//

import UIKit

class InboxViewController: UIViewController, InboxTableViewCellProtocol {
    
    var currentConversation:Conversation! = nil
    
    var isShowActivityIndicator:Bool = false
    
    
    @IBOutlet weak var sendTextField: UITextField!
    @IBOutlet weak var messageFromLabel: UILabel!
    @IBOutlet weak var messageNumberLabel: UILabel!
    @IBOutlet weak var shortCodeLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var inboxTableView: UITableView!
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var markAllAsRead_Btn: UIButton!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var messageTableViewDataSource:MessageTableViewDataSource? = nil
    var inboxTableViewDataSource:InboxTableViewDataSource? = nil
    
    var composeMessageViewController:ComposeMessageViewController!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.searchBar.delegate = self
        self.searchBar.enablesReturnKeyAutomatically = false
        self.searchBar.returnKeyType = .done
        
        self.sendTextField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
        
        self.refreshUnReadCount()
        
        messageTableViewDataSource = MessageTableViewDataSource(tableview: messageTableView)
        messageTableView.dataSource = messageTableViewDataSource
        
        inboxTableViewDataSource = InboxTableViewDataSource(tableview: inboxTableView, conversation: (User.getLoginedUser()?.conversations)!, delegate_: self)
        
        inboxTableView.dataSource = inboxTableViewDataSource
        //        inboxTableViewDataSource?.delegate = self as? InboxTableViewCellProtocol
        
        self.userNameLabel.text = User.getLoginedUser()?.serial
        initiateMessageCall()
    }
    
    @IBAction func signOut_Tapped(_ sender: Any) {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    @IBAction func refresh_Tapped(_ sender: Any) {
        
        isShowActivityIndicator = true
        
        self.getConversationUpdate()
    }
    
    @IBAction func markAllRead_Tapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Mark all as Read", message: "This feature is under developnment.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func createMessage_Tapped(_ sender: Any) {
        
        let storyboard = UIStoryboard.init(name: "ComposeMessage", bundle: nil)
        self.composeMessageViewController = storyboard.instantiateViewController(withIdentifier: "ComposeMessageViewController") as! ComposeMessageViewController
        
        self.view.addSubview(self.composeMessageViewController.view)
        
    }
    
    @IBAction func optOut_Tapped(_ sender: Any) {
        
        if (self.currentConversation == nil) {
            
            let alert = UIAlertController(title: "Warning", message: "Please select conversation first.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
            
        } else {
            ProcessingIndicator.show()
            
            User.optOutFromConversation(conversation: self.currentConversation, completionBlockSuccess: { (status: Bool) -> (Void) in
                DispatchQueue.global(qos: .background).async
                    {
                        DispatchQueue.main.async
                            {
                                
                                ProcessingIndicator.hide()
                                
                                if status == true {
                                    
                                    let alert = UIAlertController(title: "Message", message: "Number has been successfully been opted out.", preferredStyle: UIAlertControllerStyle.alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                    
                                }
                                else if status == false
                                {
                                    let alert = UIAlertController(title: "Error", message: "Number failed to opt out from list.", preferredStyle: UIAlertControllerStyle.alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
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
    
    @IBAction func deleteMessage_Tapped(_ sender: Any) {
        
        if (self.currentConversation == nil) {
            
            let alert = UIAlertController(title: "Warning", message: "Please select conversation first.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
            
        } else {
            ProcessingIndicator.show()
            
            User.deleteLocalConversation(conversation: self.currentConversation, completionBlockSuccess: { (status: Bool) -> (Void) in
                DispatchQueue.global(qos: .background).async
                    {
                        DispatchQueue.main.async
                            {
                                
                                ProcessingIndicator.hide()
                                
                                if status == true {
                                    
                                    
                                    self.inboxTableViewDataSource?.loadAfterRemoveConversation()

//                                    let alert = UIAlertController(title: "Message", message: "Conversation has been successfully been deleted.", preferredStyle: UIAlertControllerStyle.alert)
//                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//                                    self.present(alert, animated: true, completion: nil)
                                    
                                }
                                else if status == false
                                {
                                    let alert = UIAlertController(title: "Error", message: "Conversation has been failed to be deleted.", preferredStyle: UIAlertControllerStyle.alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
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
    
    @IBAction func sendMessage_Tapped(_ sender: Any) {
        
        if (currentConversation == nil) {
            
            let alert = UIAlertController(title: "Send Message", message: "Please select conversation first.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        if !((self.sendTextField.text?.isEmpty)!) {
            ProcessingIndicator.show()
            
            _ = self.sendMessageToConversation(conversation: self.currentConversation, message: self.sendTextField.text!)
            
        } else {
            
            let alert = UIAlertController(title: "Send Message", message: "Please enter message.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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

extension InboxViewController
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

extension InboxViewController:UISearchBarDelegate
{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // messageTableViewDataSource?.clearMessages(nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar,textDidChange searchText: String) {
        inboxTableViewDataSource?.applySearchFiltersForSearchText(searchText)
    }
    
}
