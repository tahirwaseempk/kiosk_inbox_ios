//
//  ConversationParser.swift
//  Inbox
//
//  Created by Amir Akram on 09/08/2017.
//  Copyright © 2017 Amir Akram. All rights reserved.
//

import Foundation
//************************************************************************************************//
//------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------//
//************************************************************************************************//
class ConversationParser: NSObject {
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    func parseConversations(json:Dictionary<String,Any>) -> Array<Conversation>
    {
        var conversations = Array<Conversation>()
        var tempDictionary = Dictionary<String,Any>()

        if json["statusCode"] != nil {
            tempDictionary["name"] = json["name"] as! String
            tempDictionary["errorCode"] = json["errorCode"] as! Int64
            tempDictionary["message"] = json["message"] as! String
            tempDictionary["statusCode"] = json["statusCode"] as! Int64
        } else {
            
            let chatsArray = json["chats"] as! Array<Dictionary<String,Any>>
           
            for dic in chatsArray
            {
                if dic.count > 0
                {
                    let contactId = dic["contactId"] as! Int64
                   
                    let unread : Bool
                    if (dic["unreadMessages"] as! Int == 1){
                        unread = true
                    } else {
                        unread = false
                    }
                    let lastMessageDict = dic["lastMessage"] as! Dictionary<String,Any>
                    let senderId = lastMessageDict["senderId"] as! Int64
                    let chatId = dic["id"] as! Int64 //lastMessageDict["chatId"] as! Int64
                    let lastMessageId = lastMessageDict["id"] as! Int64
                    let lastMessage = checkForNull(value: (lastMessageDict["text"] as AnyObject))
                    
                    var msgDate = Date()
                    if var dateStr = lastMessageDict["timeStamp"] as? String {
                        if dateStr.count > 0 {
                            dateStr = convertTimeStampToDateString(tsString: dateStr)
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = DATE_FORMATE_STRING
                            msgDate = dateFormatter.date(from: dateStr)!
                        }
                    }
                    //------------------------------------------------------------------------------------------------//
                    var conversation: Conversation? = User.getLoginedUser()?.getConverstaionFromID(chatID_: chatId);
                    //------------------------------------------------------------------------------------------------//
                    
                    if conversation == nil {
                        
                        conversation = Conversation.create(context: DEFAULT_CONTEXT,
                                                           contactId_: contactId,
                                                           unreadMessages_: unread,
                                                           timeStamp_: msgDate,
                                                           senderId_: senderId,
                                                           chatId_: chatId,
                                                           lastMessageId_: lastMessageId,
                                                           lastMessage_: lastMessage)
                        
                        conversations.append(conversation!)
                    }
                    else
                    {
                        conversation?.update(contactId_: contactId,
                                              unreadMessages_: unread,
                                              timeStamp_: msgDate,
                                              senderId_: senderId,
                                              chatId_: chatId,
                                              lastMessageId_: lastMessageId,
                                              lastMessage_: lastMessage)
                        
                        conversations.append(conversation!)
                    }
                }
            }
        }
        
        return conversations
    }
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    func checkForNull(value:AnyObject) -> String
    {
        if(value as! NSObject == NSNull() || value as! String == "")
        {
            return ""
        }
        else
        {
            return value as! String
        }
    }
}
//************************************************************************************************//
//------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------//
//************************************************************************************************//
