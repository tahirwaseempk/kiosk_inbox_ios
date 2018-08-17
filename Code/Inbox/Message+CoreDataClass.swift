//
//  Message+CoreDataClass.swift
//  Inbox
//
//  Created by Amir Akram on 07/08/2017.
//  Copyright © 2017 Amir Akram. All rights reserved.
//

import Foundation
import CoreData


public class Message: NSManagedObject {
    
}
//************************************************************************************************//
//------------------------------------------------------------------------------------------------//
//************************************************************************************************//
extension Message {
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    static func create(context: NSManagedObjectContext, msgTimeStamp_:Date, senderId_:Int64, chatId_:Int64, recipientId_:Int64, messageId_:Int64, messageText_:String, isSender_: Bool) -> Message{
        
        let message = Message(context: context)
        
        message.messageId = messageId_
        message.msgTimeStamp = msgTimeStamp_
        message.senderId = senderId_
        message.chatId = chatId_
        message.recipientId = recipientId_
        message.messageText =  messageText_.removingHTMLEntities
        message.isSender = isSender_

        return message
    }
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    func update(msgTimeStamp_:Date, senderId_:Int64, chatId_:Int64, recipientId_:Int64, messageId_:Int64, messageText_:String, isSender_: Bool) {
        
        self.messageId = messageId_
        self.msgTimeStamp = msgTimeStamp_
        self.senderId = senderId_
        self.chatId = chatId_
        self.recipientId = recipientId_
        self.messageText =  messageText_.removingHTMLEntities
        self.isSender = isSender_

    }
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
}
//************************************************************************************************//
//------------------------------------------------------------------------------------------------//
//************************************************************************************************//
