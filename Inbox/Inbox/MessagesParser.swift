//
//  MessagesParser.swift
//  Inbox
//
//  Created by Amir Akram on 21/06/2017.
//  Copyright © 2017 Amir Akram. All rights reserved.
//

import Foundation
//************************************************************************************************//
//------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------//
//************************************************************************************************//
class MessagesParser: NSObject {
    
    var conversation : Conversation!
    
    init(_ conversation_: Conversation) {
        
        self.conversation = conversation_
        super.init()
    }
    
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    func parseMessages(json:Dictionary<String,Any>) -> Array<Message>
    {
        var messages = Array<Message>()
        
        if (json["err"] as? String) != nil
        {
            return Array()
        }
        
        let inboxJson = json["chat"] as! Array<Dictionary<String,Any>>
        
        if inboxJson != nil
        {
            for dic in inboxJson
            {
                
                let check : Bool
                if (dic["direction"] as! String == "In")
                {
                    check = false
                } else {
                    check = true
                }
                
                var message: Message? = conversation.getMessageFromID(messID: dic["id"] as! Int64);
                
                var msgDate = Date()
                
                if let dateStr:String = dic["date"] as? String {
                    if dateStr.characters.count > 0 {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm:ss a"
                        msgDate = dateFormatter.date(from: dateStr)!
                    }
                }
                
                if message == nil {
                    
                    message = Message.create(context: DEFAULT_CONTEXT, date_: msgDate, message_: dic["message"] as! String, messageId_: dic["id"] as! Int64, mobile_: dic["mobile"] as! String, shortCode_: dic["shortcode"] as! String, isSender_: check, isRead_: false, updatedOn_: 0, createdOn_: 0)
                    
                    messages.append(message!)
                    
                }
                else
                {
                    
                    message?.update(date_:msgDate, message_: dic["message"] as! String, messageId_: dic["id"] as! Int64, mobile_: dic["mobile"] as! String, shortCode_: dic["shortcode"] as! String, isSender_: check, isRead_: false, updatedOn_: 0, createdOn_: 0)
                }
                
            }
        }
        
        return messages
    }
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
}
//************************************************************************************************//
//------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------//
//************************************************************************************************//
