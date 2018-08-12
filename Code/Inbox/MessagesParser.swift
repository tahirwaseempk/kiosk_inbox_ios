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
        
        var tempDictionary = Dictionary<String,Any>()
        
        if json["statusCode"] != nil {
            tempDictionary["name"] = json["name"] as! String
            tempDictionary["errorCode"] = json["errorCode"] as! String
            tempDictionary["message"] = json["message"] as! String
            tempDictionary["statusCode"] = json["statusCode"] as! String
        } else {
        
            let messagesArray = json["messages"] as! Array<Dictionary<String,Any>>

            if messagesArray.count > 0
            {
                for dic in messagesArray
                {
                    let messageId = dic["id"] as! Int64
                    let chatId = dic["chatId"] as! Int64
                    let recipientId = dic["recipientId"] as! Int64
                    let senderId = dic["senderId"] as! Int64
                    let messageText = dic["text"] as! String
//                    let messageDate = dic["timeStamp"] as! String

                    let check : Bool
//                    if (dic["senderId"] as! String == "12")
//                    {
//                        check = false
//                    } else {
                        check = true
//                    }
                    
                    var message: Message? = conversation.getMessageFromID(messID:messageId);
                    
                    var msgDate = Date()
//                    if let dateStr:String = dic["timeStamp"] as? String {
//                        if dateStr.count > 0 {
//                            let dateFormatter = DateFormatter()
//                            dateFormatter.dateFormat = DATE_FORMATE_STRING
//                            msgDate = dateFormatter.date(from: dateStr)!
//                        }
//                    }
                    
                    if message == nil {
                        
                        message = Message.create(context: DEFAULT_CONTEXT,
                                                 messageTimeStamp_:msgDate,
                                                 senderId_:senderId,
                                                 chatId_:chatId,
                                                 recipientId_:recipientId,
                                                 messageId_:messageId,
                                                 messageText_:messageText,
                                                 isSender_: check)
                        
                        messages.append(message!)
                    }
                    else {
                        
                        message?.update( messageTimeStamp_:msgDate,
                                         senderId_:senderId,
                                         chatId_:chatId,
                                         recipientId_:recipientId,
                                         messageId_:messageId,
                                         messageText_:messageText,
                                         isSender_: check)
                        
                        messages.append(message!)
                    }
                    
                }
            }
            
        }
        
        
        
        /*
        if (json["err"] as? String) != nil
        {
            return Array()
        }
        
        let inboxJson = json["chat"] as! Array<Dictionary<String,Any>>
        
        if inboxJson.count > 0
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
                    
                    if dateStr.count > 0 {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = DATE_FORMATE_STRING
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
                 
                    messages.append(message!)
                }
            }
        }
         */

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
