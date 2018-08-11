//
//  Conversation+CoreDataProperties.swift
//  Inbox
//
//  Created by Amir Akram on 07/08/2017.
//  Copyright © 2017 Amir Akram. All rights reserved.
//

import Foundation
import CoreData


extension Conversation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Conversation> {
        return NSFetchRequest<Conversation>(entityName: "Conversation")
    }

    @NSManaged public var user: User?
    @NSManaged public var messages: NSSet?

    //New Work
    //chats
    @NSManaged public var contactId: Int64
    @NSManaged public var unreadMessages: Bool
    @NSManaged public var conversationId: Int64
    //lastMessage
    @NSManaged public var timeStamp: Date
    @NSManaged public var senderId: Int64
    @NSManaged public var chatId: Int64
    @NSManaged public var lastMessageId: Int64
    @NSManaged public var lastMessage: String?
    
}

// MARK: Generated accessors for messages
extension Conversation {

    @objc(addMessagesObject:)
    @NSManaged public func addToMessages(_ value: Message)

    @objc(removeMessagesObject:)
    @NSManaged public func removeFromMessages(_ value: Message)

    @objc(addMessages:)
    @NSManaged public func addToMessages(_ values: NSSet)

    @objc(removeMessages:)
    @NSManaged public func removeFromMessages(_ values: NSSet)

}








