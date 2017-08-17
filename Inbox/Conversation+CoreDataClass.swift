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

extension Conversation {
        
    static func create(context: NSManagedObjectContext, conversationId_:Int64, mobile_:String, shortCode_:String, firstName_:String, lastName_:String, conversationDate_:String, isRead_:Bool, lastMessage_:String) ->Conversation{
        
        let conversation = Conversation(context: context)
        
        conversation.conversationId = conversationId_
        conversation.mobile = mobile_
        conversation.shortCode = shortCode_
        conversation.firstName = firstName_
        conversation.lastName = lastName_
        conversation.conversationDate = conversationDate_
        conversation.isRead = isRead_
        conversation.lastMessage = lastMessage_

        return conversation
    }
    
    func update(conversationId_:Int64, mobile_:String, shortCode_:String, firstName_:String, lastName_:String, conversationDate_:String, isRead_:Bool, lastMessage_:String) {
        
        
        self.conversationId = conversationId_
        self.mobile = mobile_
        self.shortCode = shortCode_
        self.firstName = firstName_
        self.lastName = lastName_
        self.conversationDate = conversationDate_
        self.isRead = isRead_
        self.lastMessage = lastMessage_
        
    }
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //------------------------------------------------------------------------------------------------//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    
//    static func create(context: NSManagedObjectContext, messages_:Message) {
//        
//        let conversation = Conversation(context: context)
//
//        conversation.messages = messages_
//        
//        let firstMessage  = messages_[0]
//        
//        conversation.mobile = firstMessage.mobile
//        conversation.shortCode = firstMessage.shortCode
//    }
//    
//    static func addMessage(context: NSManagedObjectContext, message:Message) -> Bool
//    {
//        
//        let conversation = Conversation(context: context)
//        conversation.messages.append(message)
//        return true
//    }

    
//    static func removeMessage(context: NSManagedObjectContext, message:Message) -> Bool
//    {
//        
//        let conversation = Conversation(context: context)
//        conversation.messages.append(message)
//        return true
//    }
//
//    
//    static func loadMessages(context: NSManagedObjectContext, message:Message) -> Message
//    {
//        
//        let conversation = Conversation(context: context)
//
//        return conversation.messages
//    }

}
