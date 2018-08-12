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
    static func create(context: NSManagedObjectContext, messageTimeStamp_:Date, senderId_:Int64, chatId_:Int64, recipientId_:Int64, messageId_:Int64, messageText_:String, isSender_: Bool) -> Message{
        
        let message = Message(context: context)
        
        message.messageId = messageId_
        message.messageTimeStamp = messageTimeStamp_
        message.senderId = senderId_
        message.chatId = chatId_
        message.recipientId = recipientId_
        message.messageText =  messageText_.removingHTMLEntities
        message.isSender = isSender_

        
//        message.messageDate = date_
//        message.message     = message_.removingHTMLEntities
//        message.mobile      = mobile_
//        message.shortCode   = shortCode_
//        message.isSender    = isSender_
//        message.isRead      = isRead_
//        message.updatedOn   = updatedOn_
//        message.createdOn   = createdOn_
        
        return message
    }
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    func update(messageTimeStamp_:Date, senderId_:Int64, chatId_:Int64, recipientId_:Int64, messageId_:Int64, messageText_:String, isSender_: Bool) {
        
        self.messageId = messageId_
        self.messageTimeStamp = messageTimeStamp_
        self.senderId = senderId_
        self.chatId = chatId_
        self.recipientId = recipientId_
        self.messageText =  messageText_.removingHTMLEntities
        self.isSender = isSender_

//        self.messageId      = messageId_
//        self.messageDate    = date_
//        self.message        = message_.removingHTMLEntities
//        self.mobile         = mobile_
//        self.shortCode      = shortCode_
//        self.isSender       = isSender_
//        self.isRead         = isRead_
//        self.updatedOn      = updatedOn_
//        self.createdOn      = createdOn_
    }
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
}
//************************************************************************************************//
//------------------------------------------------------------------------------------------------//
//************************************************************************************************//
