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

    @NSManaged public var date: String?
    @NSManaged public var messageId: Int64
    @NSManaged public var message: String?
    @NSManaged public var mobile: String?
    @NSManaged public var shortCode: String?
    @NSManaged public var isSender: Bool
    @NSManaged public var isRead: Bool
    @NSManaged public var updatedOn: Int64
    @NSManaged public var createdOn: Int64

    @NSManaged public var conversation: Conversation?

}
