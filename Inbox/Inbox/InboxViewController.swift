//
//  InboxViewController.swift
//  Inbox
//
//  Created by Amir Akram on 21/06/2017.
//  Copyright © 2017 Amir Akram. All rights reserved.
//

import UIKit

class InboxViewController: UIViewController, InboxTableViewCellProtocol {
    
    var conversations:Array<ConversationDataModel>? = nil
    
    var currentConversations:Array<ConversationDataModel>? = nil
    
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
        
        self.counterLabel.text = "(\( (conversations?.count)!))"
        
        messageTableViewDataSource = MessageTableViewDataSource(tableview: messageTableView)
        messageTableView.dataSource = messageTableViewDataSource
        
        inboxTableViewDataSource = InboxTableViewDataSource(tableview: inboxTableView, conversations_: self.conversations!, delegate_: self)
        
        inboxTableView.dataSource = inboxTableViewDataSource
        //        inboxTableViewDataSource?.delegate = self as? InboxTableViewCellProtocol
        
        initiateMessageCall()
    }
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBAction func signOut_Tapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Sign Out", message: "This functionality is underdevelopment.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        return
    }
    
    @IBAction func editMessage_Tapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Edit", message: "This functionality is underdevelopment.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        return
    }
    
    @IBAction func deleteMessage_Tapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "DELETE", message: "This functionality is underdevelopment.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        return
            
            //{"message":"??","id":1215317,"shortcode":"71441","date":"05\/27\/2017 12:46:08 PM","mobile":"1-910-445-1906"},{"message":"??","id":1215316,"shortcode":"71441","date":"05\/27\/2017 12:46:05 PM","mobile":"1-910-445-1906"},{"message":"??","id":1215315,"shortcode":"71441","date":"05\/27\/2017 12:46:03 PM","mobile":"1-910-445-1906"},{"message":"????????????????????????????????????????????????????????","id":1215295,"shortcode":"71441","date":
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
    
    func removeSpecialCharsFromString(text: String) -> String {
        let okayChars : Set<Character> =
            Set("1234567890".characters)
        return String(text.characters.filter {okayChars.contains($0) })
    }
    
    @IBAction func sendMessage_Tapped(_ sender: Any) {
        
        if !((self.sendTextField.text?.isEmpty)!) {
            
            var mobile = String ()
            var shortCode = String ()
            
            if (self.currentConversations != nil) {
                mobile     = self.currentConversations![0].mobile
                shortCode  = "71441-US"//self.currentConversations![0].shortCode
            } else {
                
                let alert = UIAlertController(title: "Warning", message: "Please select conversation first.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            mobile = removeSpecialCharsFromString(text: mobile)
            
            User.sendUserMessage(mobile: mobile, shortcode: shortCode, message: self.sendTextField.text!, completionBlockSuccess: { (sendMessaage:MessagesDataModel) -> (Void) in
                
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
            
        }
        
    }
    
    func conversationSelected(conversation:ConversationDataModel) -> Bool
    {
        
        /****************************************************************/
        self.messageFromLabel.text = ""
        self.messageNumberLabel.text = conversation.mobile
        self.shortCodeLabel.text = conversation.shortCode
        self.sendTextField.text = ""
        /****************************************************************/
        
        ProcessingIndicator.show()
        
        let mobile     =  conversation.mobile // "17326188328"
        let shortCode  =  conversation.shortCode // "71441-US"
        
        User.getCurrentConversation(mobile: mobile, shortcode: shortCode, completionBlockSuccess: {(conversations:Array<ConversationDataModel>?) -> (Void) in
            
            
            DispatchQueue.global(qos:.background).async
                {
                    DispatchQueue.main.async
                        {
                            ProcessingIndicator.hide()
                            self.currentConversations?.removeAll()
                            
                            if (conversations!.count > 0) {
                                
                                self.currentConversations = conversations
                                
                                _ = (self.messageTableViewDataSource?.loadConversation(conversation_: self.currentConversations![0]))!
                            } else {
                                
                                self.currentConversations?.removeAll()
                                
                                let emptyConversation  = ConversationDataModel(mobile_: "", shortCode_: "")
                                // let message = MessagesDataModel(date_: "", message_: "", id_:0, mobile_: "", shortCode_: "", isSender_: true)
                                _ = (self.messageTableViewDataSource?.loadConversation(conversation_: emptyConversation))!
                                
                                self.messageTableView.reloadData()
                            }
                    }
            }
            
        }) {(error:Error?) -> (Void) in
            
            DispatchQueue.global(qos:.background).async
                {
                    DispatchQueue.main.async
                        {
                            ProcessingIndicator.hide()
                            
                            self.currentConversations?.removeAll()
                            _ = (self.messageTableViewDataSource?.loadConversation(conversation_: self.currentConversations![0]))!
                            self.messageTableView.reloadData()
                            
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
        // ProcessingIndicator.show()
        
        User.getLatestConversations(completionBlockSuccess: {(conversations:Array<ConversationDataModel>?) -> (Void) in
            
            DispatchQueue.global(qos:.background).async
                {
                    DispatchQueue.main.async
                        {
                            //  ProcessingIndicator.hide()
                            
                            self.conversations = conversations
                            
                          //  self.messageTableView.reloadData()
                            
                            self.inboxTableView.reloadData()
                            
                            self.counterLabel.text = "(\( (conversations?.count)!))"
                            
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
                            //ProcessingIndicator.hide()
                            self.getConversationUpdate()
                    }
            }
        }
    }
}
