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
    
//    func getMessageFromID(messID: Int64) -> Message? {
//
//        let filteredMessages = self.conversation?.messages?.filter { ($0 as! Message).messageId == messID }
//
//        if (filteredMessages?.count)! > 0 {
//            return filteredMessages?.first as? Message
//        }
//
//        return nil;
//    }
    
}

extension Message {
    
    static func create(context: NSManagedObjectContext, date_:String,message_:String, messageId_:Int64, mobile_:String, shortCode_:String, isSender_:Bool, isRead_:Bool, updatedOn_:Int64, createdOn_:Int64) -> Message{
        
        let message = Message(context: context)
        
        message.messageId = messageId_
        message.date = date_
        message.message = message_
        message.mobile = mobile_
        message.shortCode = shortCode_
        message.isSender = isSender_
        message.isRead = isRead_
        message.updatedOn = updatedOn_
        message.createdOn = createdOn_
        
        return message
    }
    
    func update(date_:String,message_:String, messageId_:Int64, mobile_:String, shortCode_:String, isSender_:Bool, isRead_:Bool, updatedOn_:Int64, createdOn_:Int64) {
        
        self.messageId = messageId_
        self.date = date_
        self.message = message_
        self.mobile = mobile_
        self.shortCode = shortCode_
        self.isSender = isSender_
        self.isRead = isRead_
        self.updatedOn = updatedOn_
        self.createdOn = createdOn_
    }
    
}
