//
//  MessagesDataModel.swift
//  Inbox
//
//  Created by Amir Akram on 21/06/2017.
//  Copyright © 2017 Amir Akram. All rights reserved.
//

import UIKit

class ConversationDataModel: NSObject {
    
    var messages:Array<MessagesDataModel>

    var mobile:String
    
    var shortCode:String

    init(mobile_:String, shortCode_:String) {
        
        self.messages = Array<MessagesDataModel>()
        
        self.mobile = mobile_
        self.shortCode = shortCode_

        super.init()
    }

    init(messages_:Array<MessagesDataModel>) {
        
        self.messages = messages_
        
        let firstMessage  = messages_[0]
        
        self.mobile = firstMessage.mobile
        self.shortCode = firstMessage.shortCode

        super.init()
    }
    
    func addMessage(message:MessagesDataModel) -> Bool
    {
        self.messages.append(message)
        
        return true
    }
    
    func removeMessage(message:MessagesDataModel) -> Bool
    {
       // self.messages.remo(message)
        
        return true
    }

    func loadMessages(message:MessagesDataModel) -> MessagesDataModel
    {
        //Do something here
        return message
    }
    
}
