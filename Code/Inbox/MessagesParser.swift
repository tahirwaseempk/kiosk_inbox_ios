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
                    
                    let check : Bool
                    if (senderId  == User.loginedUser?.userId)
                    {
                        check = true
                    } else {
                        check = false
                    }
                    
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
                                                 msgTimeStamp_:msgDate,
                                                 senderId_:senderId,
                                                 chatId_:chatId,
                                                 recipientId_:recipientId,
                                                 messageId_:messageId,
                                                 messageText_:messageText,
                                                 isSender_: check)
                        
                        messages.append(message!)
                    }
                    else {
                        
                        message?.update( msgTimeStamp_:msgDate,
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
