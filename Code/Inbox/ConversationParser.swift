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
        
        if (json["err"] as? String) != nil
        {
            return Array()
        }
        let inboxJson = json["inbox"] as! Array<Dictionary<String,Any>>
        
        if inboxJson.count > 0
        {
            
            for dic in inboxJson
            {
                
                let unread : Bool
                
                if (dic["unread"] as! Int == 1)
                {
                    unread = true
                } else {
                    unread = false
                }
                
                var conversation: Conversation? = User.getLoginedUser()?.getConverstaionFromID(conID: dic["id"] as! Int64);
                
                var msgDate = Date()
                
                if let dateStr:String = dic["date"] as? String {
                    
                    if dateStr.count > 0 {
                        
                        let dateFormatter = DateFormatter()
                        
                        dateFormatter.dateFormat = DATE_FORMATE_STRING
                        
                        msgDate = dateFormatter.date(from: dateStr)!
                    }
                }
                
                if conversation == nil {
                    
                    conversation = Conversation.create(context: DEFAULT_CONTEXT, conversationId_: dic["id"] as! Int64, mobile_: dic["mobile"] as! String, shortCode_: dic["shortcode"] as! String, firstName_: dic["first"] as! String, lastName_: dic["last"] as! String, conversationDate_:msgDate, isRead_: unread, lastMessage_: dic["message"] as! String, shortcodeDisplay_: dic["shortcodeDisplay"] as! String, mobileNumber_: dic["mobileNumber"] as! String, tollFree_: dic["tollFree"] as! String)
                    
                    conversations.append(conversation!)
                }
                else
                {
                    conversation?.update(conversationId_: dic["id"] as! Int64, mobile_: dic["mobile"] as! String, shortCode_: dic["shortcode"] as! String, firstName_: dic["first"] as! String, lastName_: dic["last"] as! String, conversationDate_: msgDate, isRead_: unread, lastMessage_: dic["message"] as! String, shortcodeDisplay_: dic["shortcodeDisplay"] as! String, mobileNumber_: dic["mobileNumber"] as! String, tollFree_: dic["tollFree"] as! String)
                    
                    conversations.append(conversation!)
                }
            }
        }
        
        return conversations
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
