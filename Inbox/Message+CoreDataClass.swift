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
}
