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
                
            let message = Message.create(context: DEFAULT_CONTEXT, date_: dic["date"] as! String, message_: dic["message"] as! String, messageId_: dic["id"] as! Int64, mobile_: dic["mobile"] as! String, shortCode_: dic["shortcode"] as! String, isSender_: check, isRead_: false, updatedOn_: 0, createdOn_: 0)
                
                messages.append(message)
    
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
