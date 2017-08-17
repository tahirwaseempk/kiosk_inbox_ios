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
        
        if inboxJson != nil
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
                
                if conversation == nil {
                    
                    conversation = Conversation.create(context: DEFAULT_CONTEXT, conversationId_: dic["id"] as! Int64, mobile_: dic["mobile"] as! String, shortCode_: dic["shortcode"] as! String, firstName_: dic["first"] as! String, lastName_: dic["last"] as! String, conversationDate_: dic["date"] as! String, isRead_: unread, lastMessage_: dic["message"] as! String)
                    
                    conversations.append(conversation!)
                }
                else
                {
                    
                    conversation?.update(conversationId_: dic["id"] as! Int64, mobile_: dic["mobile"] as! String, shortCode_: dic["shortcode"] as! String, firstName_: dic["first"] as! String, lastName_: dic["last"] as! String, conversationDate_: dic["date"] as! String, isRead_: unread, lastMessage_: dic["message"] as! String)
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
