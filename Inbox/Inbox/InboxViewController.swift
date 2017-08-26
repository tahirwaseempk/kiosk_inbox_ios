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
    
    @IBOutlet weak var sendTextField: UITextField!
    @IBOutlet weak var messageFromLabel: UILabel!
    @IBOutlet weak var messageNumberLabel: UILabel!
    @IBOutlet weak var shortCodeLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var inboxTableView: UITableView!
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var messageTableViewDataSource:MessageTableViewDataSource? = nil
    var inboxTableViewDataSource:InboxTableViewDataSource? = nil
    
    var composeMessageViewController:ComposeMessageViewController!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.searchBar.delegate = self
        self.searchBar.enablesReturnKeyAutomatically = false
        self.searchBar.returnKeyType = .done
        
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
    
    @IBAction func deleteMessage_Tapped(_ sender: Any) {
        
        if (self.currentConversation == nil) {
            
            let alert = UIAlertController(title: "Warning", message: "Please select conversation first.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
            
        } else {
            
            User.optOutFromConversation(conversation: self.currentConversation, completionBlockSuccess: { (status: Bool) -> (Void) in
                DispatchQueue.global(qos: .background).async
                    {
                        DispatchQueue.main.async
                            {
                                
                                if status == true {
                                    
                                    //  self.initiateMessageCall()
                                    
                                    let alert = UIAlertController(title: "Message", message: "Sucessfully unsubscribed from conversation.", preferredStyle: UIAlertControllerStyle.alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                    
                                }
                                else
                                {
                                    let alert = UIAlertController(title: "Error", message: "Some error occured at server end. Please try again later.", preferredStyle: UIAlertControllerStyle.alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                    //                                    let alert = UIAlertController(title: "Message", message: "Sucessfully unsubscribed from conversation.", preferredStyle: UIAlertControllerStyle.alert)
                                    //                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                                    //                                    self.present(alert, animated: true, completion: nil)
                                }
                        }
                }
            }, andFailureBlock: { (error: Error?) -> (Void) in
                
                DispatchQueue.global(qos: .background).async
                    {
                        DispatchQueue.main.async
                            {
                                
                                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                                //                                let alert = UIAlertController(title: "Message", message: "Sucessfully unsubscribed from conversation.", preferredStyle: UIAlertControllerStyle.alert)
                                //                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                                //                                self.present(alert, animated: true, completion: nil)
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
        self.shortCodeLabel.text = conversation.shortCode
        self.sendTextField.text = ""
        
        if conversation.isRead == true {
            
            conversation.isRead = false
            self.inboxTableViewDataSource?.reloadControls()
            self.refreshUnReadCount()
            
            do {
                
                try conversation.managedObjectContext?.save()
            }
            catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
            
        }
        /****************************************************************/
        
        ProcessingIndicator.show()
        
        User.getMessageForConversation(self.currentConversation, completionBlockSuccess: {(messages:Array<Message>?) -> (Void) in
            
            
            DispatchQueue.global(qos:.background).async
                {
                    DispatchQueue.main.async
                        {
                            ProcessingIndicator.hide()
                            
//                            if ((self.currentConversation.messages?.count)! > 0) {
                            
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
            self.getConversationUpdate()
        }
    }
    
    func getConversationUpdate() {
        User.getLatestConversations(completionBlockSuccess: {(conversations:Array<Conversation>?) -> (Void) in
            
            DispatchQueue.global(qos:.background).async
                {
                    DispatchQueue.main.async
                        {
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
                            self.sendTextField.text = ""
                    }
            }
            _ = self.messageTableViewDataSource?.addNewMessage(sendMessaage)
            
        }) { (error:Error?) -> (Void) in
            DispatchQueue.global(qos:.background).async
                {
                    DispatchQueue.main.async
                        {
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
