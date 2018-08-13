//
//  ConversationParser.swift
//  Inbox
//
//  Created by Amir Akram on 09/08/2017.
//  Copyright © 2017 Amir Akram. All rights reserved.
//

import Foundation

class UserContactsParser: NSObject
{
    func parseUserContacts(json:Dictionary<String,Any>) -> Array<UserContact>
    {
        var contacts = Array<UserContact>()
        
        var tempDictionary = Dictionary<String,Any>()

       /* if json["statusCode"] != nil {
            tempDictionary["name"] = json["name"] as! String
            tempDictionary["errorCode"] = json["errorCode"] as! String
            tempDictionary["message"] = json["message"] as! String
            tempDictionary["statusCode"] = json["statusCode"] as! String
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
                    let conversationId = dic["id"] as! Int64
                    let lastMessageDict = dic["lastMessage"] as! Dictionary<String,Any>
                    //                    let timeStamp = lastMessagenDict["timeStamp"] as! String
                    let senderId = lastMessageDict["senderId"] as! Int64
                    let chatId = lastMessageDict["chatId"] as! Int64
                    let lastMessageId = lastMessageDict["id"] as! Int64
                    let lastMessage = lastMessageDict["text"] as! String
                   
                    var conversation: Conversation? = User.getLoginedUser()?.getConverstaionFromID(conID: conversationId);
                    
                    var msgDate = Date()
                    if let dateStr:String = dic["timeStamp"] as? String {
                        if dateStr.count > 0 {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = DATE_FORMATE_STRING
                            msgDate = dateFormatter.date(from: dateStr)!
                        }
                    }
                    
                    if conversation == nil {
                        
                        conversation = Conversation.create(context: DEFAULT_CONTEXT,
                                                           contactId_: contactId,
                                                           unreadMessages_: unread,
                                                           conversationId_: conversationId,
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
                                              conversationId_: conversationId,
                                              timeStamp_: msgDate,
                                              senderId_: senderId,
                                              chatId_: chatId,
                                              lastMessageId_: lastMessageId,
                                              lastMessage_: lastMessage)
                        
                        conversations.append(conversation!)
                    }
                }
            }
        } */
        
        return contacts
    }
}
