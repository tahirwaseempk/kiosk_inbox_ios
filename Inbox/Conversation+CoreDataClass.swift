//
//  Conversation+CoreDataClass.swift
//  Inbox
//
//  Created by Amir Akram on 07/08/2017.
//  Copyright © 2017 Amir Akram. All rights reserved.
//

import Foundation
import CoreData


public class Conversation: NSManagedObject {
    
     func getMessageFromID(messID: Int64) -> Message? {
        
        let filteredMessages = messages?.filter { ($0 as! Message).messageId == messID }
        
        if (filteredMessages?.count)! > 0 {
            return filteredMessages?.first as? Message
        }
        
        return nil;
    }

}

//************************************************************************************************//
//------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------//
//************************************************************************************************//

extension Conversation {
    
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    
    static func create(context: NSManagedObjectContext, conversationId_:Int64, mobile_:String, shortCode_:String, firstName_:String, lastName_:String, conversationDate_:Date, isRead_:Bool, lastMessage_:String, shortcodeDisplay_: String, mobileNumber_: String) ->Conversation{
        
        let conversation = Conversation(context: context)
        
        conversation.conversationId = conversationId_
        conversation.mobile = mobile_
        conversation.shortCode = shortCode_
        conversation.firstName = firstName_
        conversation.lastName = lastName_
        conversation.conversationDate = conversationDate_
        conversation.isRead = isRead_
        conversation.lastMessage = lastMessage_

        conversation.shortcodeDisplay = shortcodeDisplay_
        conversation.mobileNumber = mobileNumber_

        return conversation
    }
    
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    
    func update(conversationId_:Int64, mobile_:String, shortCode_:String, firstName_:String, lastName_:String, conversationDate_:Date, isRead_:Bool, lastMessage_:String, shortcodeDisplay_: String, mobileNumber_: String) {
        
        
        self.conversationId = conversationId_
        self.mobile = mobile_
        self.shortCode = shortCode_
        self.firstName = firstName_
        self.lastName = lastName_
        self.conversationDate = conversationDate_
        self.isRead = isRead_
        self.lastMessage = lastMessage_
        
        self.shortcodeDisplay = shortcodeDisplay_
        self.mobileNumber = mobileNumber_
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
