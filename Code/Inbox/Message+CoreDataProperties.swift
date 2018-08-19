//
//  Message+CoreDataProperties.swift
//  Inbox
//
//  Created by Amir Akram on 07/08/2017.
//  Copyright © 2017 Amir Akram. All rights reserved.
//

import Foundation
import CoreData


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged public var conversation: Conversation?

    //New Work
    @NSManaged public var msgTimeStamp: Date
    @NSManaged public var senderId: Int64
    @NSManaged public var chatId: Int64
    @NSManaged public var recipientId: Int64
    @NSManaged public var messageId: Int64
    @NSManaged public var messageText: String?
    @NSManaged public var isSender: Bool
    
    @NSManaged var receiver:UserContact?
    @NSManaged var sender:UserContact?

}



