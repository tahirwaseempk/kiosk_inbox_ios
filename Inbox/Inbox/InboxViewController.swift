//
//  InboxViewController.swift
//  Inbox
//
//  Created by Amir Akram on 21/06/2017.
//  Copyright © 2017 Amir Akram. All rights reserved.
//

import UIKit

class InboxViewController: UIViewController, InboxTableViewCellProtocol {
    
//    var conversations : Array<Conversation>? = nil
    var currentConversation:Conversation! = nil
    
    @IBOutlet weak var sendTextField: UITextField!
    @IBOutlet weak var messageFromLabel: UILabel!
    @IBOutlet weak var messageNumberLabel: UILabel!
    @IBOutlet weak var shortCodeLabel: UILabel!
    
    
    
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var inboxTableView: UITableView!
    @IBOutlet weak var messageTableView: UITableView!
    
    var messageTableViewDataSource:MessageTableViewDataSource? = nil
    
    var inboxTableViewDataSource:InboxTableViewDataSource? = nil
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        self.counterLabel.text = "(\(String(describing:  (User.getLoginedUser()?.conversations?.count))))"
        
        messageTableViewDataSource = MessageTableViewDataSource(tableview: messageTableView)
        messageTableView.dataSource = messageTableViewDataSource
        
        inboxTableViewDataSource = InboxTableViewDataSource(tableview: inboxTableView, delegate_: self)
        
        inboxTableView.dataSource = inboxTableViewDataSource
        //        inboxTableViewDataSource?.delegate = self as? InboxTableViewCellProtocol
        
        self.userNameLabel.text = "test-test"
        initiateMessageCall()
    }
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBAction func signOut_Tapped(_ sender: Any) {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func deleteMessage_Tapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Opt Out", message: "This functionality is underdevelopment.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        return
        
        /*
         WebManager.deleteMessage(UDID: "", serial: "", Ids: "", completionBlockSuccess: { (Bool) -> (Void) in
         
         DispatchQueue.global(qos: .background).async
         {
         DispatchQueue.main.async
         {
         let alert = UIAlertController(title: "Message", message: "Message sucessfully deleted.", preferredStyle: UIAlertControllerStyle.alert)
         alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
         self.present(alert, animated: true, completion: nil)
         }
         }
         
         }) { (error:Error?) -> (Void) in
         
         let alert = UIAlertController(title: "Error", message: "Unable to delete message at the moment.", preferredStyle: UIAlertControllerStyle.alert)
         alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
         self.present(alert, animated: true, completion: nil)
         }
         */
    }
    
    
    @IBAction func sendMessage_Tapped(_ sender: Any) {
        
        if !((self.sendTextField.text?.isEmpty)!) {
            
            
            if (self.currentConversation == nil) {
                
                let alert = UIAlertController(title: "Warning", message: "Please select conversation first.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                return
            }
            
            User.sendUserMessage(conversation: self.currentConversation, message: self.sendTextField.text!, completionBlockSuccess: { (sendMessaage:Message) -> (Void) in
                
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
                                
                                let alert = UIAlertController(title: "Error", message: "Unable to send message at the moment.", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                        }
                }
            }
            
        } else {
            
            let alert = UIAlertController(title: "Message", message: "Please enter message.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
    }
    
    func conversationSelected(conversation:Conversation) -> Bool
    {
        
        self.currentConversation = conversation
        /****************************************************************/
        self.messageFromLabel.text = (currentConversation.firstName)! + (currentConversation.lastName)!
        self.messageNumberLabel.text = conversation.mobile
        self.shortCodeLabel.text = conversation.shortCode
        self.sendTextField.text = ""
        /****************************************************************/
        
        ProcessingIndicator.show()
        
        User.getMessageForConversation(self.currentConversation, completionBlockSuccess: {(messages:Array<Message>?) -> (Void) in
            
            
            DispatchQueue.global(qos:.background).async
                {
                    DispatchQueue.main.async
                        {
                            ProcessingIndicator.hide()
                            
                            if ((self.currentConversation.messages?.count)! > 0) {
                                
                                _ = (self.messageTableViewDataSource?.loadConversation(conversation_: self.currentConversation))!
                            
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
    
    @IBAction func markAllButton_Tapped(_ sender: Any)
    {
        
    }
}

extension InboxViewController
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
        User.getLatestConversations(completionBlockSuccess: {(conversations:Array<Conversation>?) -> (Void) in
            
            DispatchQueue.global(qos:.background).async
                {
                    DispatchQueue.main.async
                        {
                            
                            self.inboxTableView.reloadData()
                            
                            self.counterLabel.text = "(\(String(describing:  (User.getLoginedUser()?.conversations?.count))))"
                            
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
}
