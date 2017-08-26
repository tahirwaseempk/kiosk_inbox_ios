//
//  MessageTableViewDataSource.swift
//  Inbox
//
//  Created by Amir Akram on 21/06/2017.
//  Copyright © 2017 Amir Akram. All rights reserved.
//

import Foundation
import UIKit

class MessageTableViewDataSource:NSObject,UITableViewDelegate,UITableViewDataSource {
    
    let targetedTableView: UITableView
    var selectedConversation:Conversation! = nil
    var chatCell:ChatTableViewCell!
    var chatCellSettings:ChatCellSettings!
    
    init(tableview:UITableView) {
        
        self.targetedTableView = tableview
        
        self.targetedTableView.register(ChatTableViewCell.self, forCellReuseIdentifier: "chatSend")
        self.targetedTableView.register(ChatTableViewCell.self, forCellReuseIdentifier: "chatReceive")
        
        //Getting singleton instances of the required classes
        chatCellSettings = ChatCellSettings.getInstance()
        
        /* ///////////////////////////////
         Set settings for Application
         /////////////////////////////// */
        
        chatCellSettings?.setSenderBubbleColorHex("007AFF");
        chatCellSettings?.setSenderBubbleNameTextColorHex("FFFFFF");
        chatCellSettings?.setSenderBubbleMessageTextColorHex("FFFFFF");
        chatCellSettings?.setSenderBubbleTimeTextColorHex("FFFFFF");
        
        chatCellSettings?.setReceiverBubbleColorHex("DFDEE5");
        chatCellSettings?.setReceiverBubbleNameTextColorHex("000000");
        chatCellSettings?.setReceiverBubbleMessageTextColorHex("000000");
        chatCellSettings?.setReceiverBubbleTimeTextColorHex("000000");
        
        chatCellSettings?.setSenderBubbleFontWithSizeForName(UIFont.boldSystemFont(ofSize: 10))
        chatCellSettings.setSenderBubbleFontWithSizeForMessage(UIFont.systemFont(ofSize: 14))
        chatCellSettings.setSenderBubbleFontWithSizeForTime(UIFont.systemFont(ofSize: 10))
        
        chatCellSettings.setReceiverBubbleFontWithSizeForName(UIFont.boldSystemFont(ofSize: 10))
        chatCellSettings.setReceiverBubbleFontWithSizeForMessage(UIFont.systemFont(ofSize: 14))
        chatCellSettings.setReceiverBubbleFontWithSizeForTime(UIFont.systemFont(ofSize: 10))
        
        chatCellSettings?.senderBubbleTailRequired(false)
        chatCellSettings?.receiverBubbleTailRequired(false)
        
        super.init()
        
        self.targetedTableView.dataSource = self
        self.targetedTableView.delegate = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        guard (self.selectedConversation == nil) else {
            return (self.selectedConversation.messages!.count)
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let message:Message = (self.selectedConversation.messages?.allObjects[indexPath.row] as! Message)
        
        //        let date = Date()
        //        let formatter = DateFormatter()
        //        formatter.dateFormat = "dd-MM-yyyy hh:mm:ss"
        //        let result = formatter.string(from: date)
        
        // let timestamp = NSDate().timeIntervalSince1970
        // let date = Date(timeIntervalSince1970: timestamp)
        // let dateFormatter = DateFormatter()
        // dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        // dateFormatter.locale = NSLocale.current
        // dateFormatter.dateFormat = "dd-MM-yyy hh:mm:ss" //Specify your format that you want
        // let strDate = dateFormatter.string(from: date)
        //
        //        let inFormatter = DateFormatter()
        //        inFormatter.dateFormat = "mm/dd/yyy hh:mm:ss a"
        //
        //        let outFormatter = DateFormatter()
        //        outFormatter.dateFormat = "hh:mm"
        //
        //        let date = inFormatter.date(from: message.date!)
        //        let outStr = outFormatter.string(from: date!)
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy hh:mm:ss a"
        let outStr = formatter.string(from: message.messageDate)
        
        if (message.isSender == false) {
            
            chatCell = tableView.dequeueReusableCell(withIdentifier: "chatSend", for: indexPath)as? ChatTableViewCell
            
            chatCell.chatMessageLabel.text = message.message
            chatCell.chatNameLabel.text = message.mobile
            chatCell.chatTimeLabel.text = outStr
            //chatCell.chatUserImage.image = UIImage(named: "defaultUser.png")
            chatCell.authorType = AuthorType.iMessageBubbleTableViewCellAuthorTypeReceiver
            
        } else {
            
            chatCell = tableView.dequeueReusableCell(withIdentifier: "chatReceive", for: indexPath)as? ChatTableViewCell
            
            chatCell.chatMessageLabel.text = message.message
            chatCell.chatNameLabel.text = "Me"
            chatCell.chatTimeLabel.text = outStr
            //chatCell.chatUserImage.image = UIImage(named: "defaultUser.png")
            chatCell.authorType = AuthorType.iMessageBubbleTableViewCellAuthorTypeSender
        }
        
        return chatCell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
        let message:Message = (self.selectedConversation.messages?.allObjects[indexPath.row] as! Message)
        
        var size = CGSize(width: 0, height: 0)
        var Namesize:CGSize
        var Timesize:CGSize
        var Messagesize:CGSize
        
        var fontArray:NSArray = NSArray()
        
        //Get the chal cell font settings. This is to correctly find out the height of each of the cell according to the text written in those cells which change according to their fonts and sizes.
        //If you want to keep the same font sizes for both sender and receiver cells then remove this code and manually enter the font name with size in Namesize, Messagesize and Timesize.
        
        
        if(message.isSender == false)
        {
            fontArray = chatCellSettings.getReceiverBubbleFontWithSize()! as NSArray;
        }
        else
        {
            fontArray = chatCellSettings.getSenderBubbleFontWithSize()! as NSArray;
        }
        
        let nameSize = CGSize(width: 220.0, height: CGFloat.greatestFiniteMagnitude)
        Namesize = ("Name" as NSString).boundingRect(with: nameSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName : fontArray[0]], context: nil).size
        
        let messageSize = CGSize(width: 220.0, height: CGFloat.greatestFiniteMagnitude)
        Messagesize = (message.message! as NSString).boundingRect(with: messageSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:fontArray[1]], context: nil).size
        
        let timeSize = CGSize(width: 220.0, height: CGFloat.greatestFiniteMagnitude)
        Timesize = ("Time" as NSString).boundingRect(with: timeSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName : fontArray[2]], context: nil).size
        
        size.height = Messagesize.height + Namesize.height + Timesize.height + 48.0
        
        return size.height
    }
    
    func tableView(_ tableView:UITableView,didSelectRowAt indexPath:IndexPath)
    {
        
    }
    
    func loadConversation(conversation_: Conversation) -> Bool {
        
        self.selectedConversation = conversation_;
        //        self.conversationMessages = self.selectedConversation.messages?.allObjects as! Array<Message>
        self.targetedTableView.reloadData()
        
        let rowCount = self.selectedConversation?.messages?.count
        
        if rowCount!>0 {
            let indexPath = IndexPath(row:(self.selectedConversation?.messages?.count)! - 1, section: 0)
            self.targetedTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
        
        return true
    }
    
    func addNewMessage(_ message:Message) -> Bool {
        
        self.targetedTableView.reloadData()

        return false
    }
    
    func clearMessages(_ conversation:Conversation?)
    {
        self.selectedConversation = conversation
        self.targetedTableView.reloadData()
    }
}

