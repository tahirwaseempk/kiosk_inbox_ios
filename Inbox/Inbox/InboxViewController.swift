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
    
    @IBAction func byFeature_Tapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "BY FEATURE", message: "This functionality is underdevelopment.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func mostRecent_Tapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "MOST RECENT", message: "This functionality is underdevelopment.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func deleteMessage_Tapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "DELETE", message: "This functionality is underdevelopment.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
        //{"message":"??","id":1215317,"shortcode":"71441","date":"05\/27\/2017 12:46:08 PM","mobile":"1-910-445-1906"},{"message":"??","id":1215316,"shortcode":"71441","date":"05\/27\/2017 12:46:05 PM","mobile":"1-910-445-1906"},{"message":"??","id":1215315,"shortcode":"71441","date":"05\/27\/2017 12:46:03 PM","mobile":"1-910-445-1906"},{"message":"????????????????????????????????????????????????????????","id":1215295,"shortcode":"71441","date":
        
        
        /*
         WebManager.deleteMessage(UDID: udid, serial: serial, Ids: Ids, completionBlockSuccess: { (Bool) -> (Void) in
         
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
         
         
         }
         */
    }
    
    @IBAction func sendMessage_Tapped(_ sender: Any) {
        
        let mobile     = "17326188328"
        let shortCode  = "71441-US"
        
        User.sendUserMessage(mobile: mobile, shortcode: shortCode, completionBlockSuccess: { (sendMessaage:MessagesDataModel) -> (Void) in
            
            self.sendTextField.text = ""
            _ = self.messageTableViewDataSource?.addNewMessage(sendMessaage)
            
        }) { (error:Error?) -> (Void) in
            
            let alert = UIAlertController(title: "Message", message: "Please enter message.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
        
        //        let date = Date()
        //        let formatter = DateFormatter()
        //        formatter.dateFormat = "dd-MM-yyyy hh:mm:ss"
        //        let result = formatter.string(from: date)
        
        /*
         if !((self.sendTextField.text?.isEmpty)!) {
         
         let timestamp = NSDate().timeIntervalSince1970
         
         let date = Date(timeIntervalSince1970: timestamp)
         let dateFormatter = DateFormatter()
         dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
         dateFormatter.locale = NSLocale.current
         dateFormatter.dateFormat = "dd-MM-yyy hh:mm:ss" //Specify your format that you want
         let strDate = dateFormatter.string(from: date)
         
         let sendMessaage = MessagesDataModel(date_: strDate, message_: self.sendTextField.text!, id_: 0, mobile_: "Me", shortCode_: "", isSender_: true)
         
         self.sendTextField.text = ""
         
         _ = messageTableViewDataSource?.addNewMessage(sendMessaage)
         
         } else {
         
         let alert = UIAlertController(title: "Message", message: "Please enter message.", preferredStyle: UIAlertControllerStyle.alert)
         alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
         self.present(alert, animated: true, completion: nil)
         
         }
         */
    }
    
    func conversationSelected(conversation:ConversationDataModel) -> Bool
    {
        
        /****************************************************************/
        self.messageFromLabel.text = ""
        self.messageNumberLabel.text = conversation.mobile
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
                            self.messageTableView.reloadData()
                            
                            let alert = UIAlertController(title: "ERROR", message: "Could not load conversation.", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                    }
            }
        }
        
        return true
        //        return (messageTableViewDataSource?.loadConversation(conversation_: self.currentConversations![0]))!
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
        ProcessingIndicator.show()
        
        User.getLatestConversations(completionBlockSuccess: {(conversations:Array<ConversationDataModel>?) -> (Void) in
            
            DispatchQueue.global(qos:.background).async
                {
                    DispatchQueue.main.async
                        {
                            ProcessingIndicator.hide()
                            
                            self.conversations = conversations
                            
                            self.messageTableView.reloadData()
                            
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
                            ProcessingIndicator.hide()
                            self.getConversationUpdate()
                    }
            }
        }
    }
}
