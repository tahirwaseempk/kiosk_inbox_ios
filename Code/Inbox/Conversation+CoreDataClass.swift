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
        
//        let filteredMessages = messages?.filter { ($0 as! Message).messageId == messID }
//
//        if (filteredMessages?.count)! > 0 {
//            return filteredMessages?.first as? Message
//        }
//
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
    
    static func create(context: NSManagedObjectContext,contactId_: Int64, unreadMessages_: Bool, conversationId_: Int64, timeStamp_: Date, senderId_: Int64, chatId_: Int64, lastMessageId_: Int64, lastMessage_: String) -> Conversation {
        
        let conversation = Conversation(context: context)
        
        //NEW WORK
        conversation.contactId = contactId_
        conversation.unreadMessages = unreadMessages_
        conversation.conversationId = conversationId_
        conversation.timeStamp = timeStamp_
        conversation.senderId = senderId_
        conversation.chatId = chatId_
        conversation.lastMessageId = lastMessageId_
        conversation.lastMessage = lastMessage_
        
        return conversation
    }
    
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    
    func update(contactId_: Int64, unreadMessages_: Bool, conversationId_: Int64, timeStamp_: Date, senderId_: Int64, chatId_: Int64, lastMessageId_: Int64, lastMessage_: String) {
        
        //NEW WORK
        self.contactId = contactId_
        self.unreadMessages = unreadMessages_
        self.conversationId = conversationId_
        self.timeStamp = timeStamp_
        self.senderId = senderId_
        self.chatId = chatId_
        self.lastMessageId = lastMessageId_
        self.lastMessage = lastMessage_
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
