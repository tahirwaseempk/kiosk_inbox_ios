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
        
        inboxTableViewDataSource = InboxTableViewDataSource(tableview: inboxTableView, conversations_: self.conversations!, delegate_: (self as? InboxTableViewCellProtocol)!)
        inboxTableView.dataSource = inboxTableViewDataSource
        //        inboxTableViewDataSource?.delegate = self as? InboxTableViewCellProtocol
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func deleteMessage_Tapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Message", message: "This functionality is underdevelopment.", preferredStyle: UIAlertControllerStyle.alert)
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
        
        let alert = UIAlertController(title: "Message", message: "This functionality is underdevelopment.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func conversationSelected(conversation:ConversationDataModel) -> Bool
    {
        self.messageFromLabel.text = ""
        self.messageNumberLabel.text = conversation.mobile
        
        return (messageTableViewDataSource?.loadConversation(conversation_: conversation))!
    }
    
    
    @IBAction func markAllButton_Tapped(_ sender: Any) {
    }
}
