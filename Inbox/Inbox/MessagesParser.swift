//
//  MessagesParser.swift
//  Inbox
//
//  Created by Amir Akram on 21/06/2017.
//  Copyright © 2017 Amir Akram. All rights reserved.
//

import UIKit

class MessagesParser: NSObject {

    func parseInboxMessages(json:Dictionary<String,Any>) -> Array<ConversationDataModel>
    {
        var conversations = Array<ConversationDataModel>()

        let inboxJson = json["inbox"] as! Array<Dictionary<String,Any>>
        
        var messages = Array<MessagesDataModel>()
        
        if inboxJson != nil
        {
            for dic in inboxJson
            {
                var message = MessagesDataModel(date_: dic["date"] as! String, message_: dic["message"] as! String, id_: dic["id"] as! Int32, mobile_: dic["mobile"] as! String, shortCode_: dic["shortcode"] as! String)
                
                let mobile = dic["mobile"] as! String 
                
                var targetedConversation:ConversationDataModel? = nil
                
                for conversation in conversations
                {
                    if conversation.mobile == mobile
                    {
                        targetedConversation = conversation
                    }
                }
                
                if targetedConversation == nil
                {
                    targetedConversation = ConversationDataModel(mobile_:mobile)
                    
                    conversations.append(targetedConversation!)
                }
                
                targetedConversation?.addMessage(message: message)
            }
        }

        return conversations
    }
}
