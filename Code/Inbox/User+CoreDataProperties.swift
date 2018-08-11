//
//  User+CoreDataProperties.swift
//  Inbox
//
//  Created by Amir Akram on 07/08/2017.
//  Copyright © 2017 Amir Akram. All rights reserved.
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var uuid: String?
    @NSManaged public var serial: String?
    @NSManaged public var conversations: NSSet?
  
    @NSManaged public var isRemember: Bool
    
    @nonobjc static var loginedUser:User? = nil
    
    // New Work //
    @NSManaged public var token: String?
    //user
    @NSManaged public var userId: Int64
    @NSManaged public var username: String?
    @NSManaged public var formattedUsername: String?
    @NSManaged public var email: String?
    @NSManaged public var phone: String?
    @NSManaged public var mobile: String?
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var companyName: String?
    //locationDetails
    @NSManaged public var address: String?
    @NSManaged public var city: String?
    @NSManaged public var country: String?
    @NSManaged public var state: String?
    @NSManaged public var zipCode: String?
    //
    @NSManaged public var whiteLableConfigurationId: Int64
    @NSManaged public var userGroupId: Int64
    @NSManaged public var timezone: Int64
    @NSManaged public var license: String?
}
    
// MARK: Generated accessors for conversations
extension User {

    @objc(addConversationsObject:)
    @NSManaged public func addToConversations(_ value: Conversation)

    @objc(removeConversationsObject:)
    @NSManaged public func removeFromConversations(_ value: Conversation)

    @objc(addConversations:)
    @NSManaged public func addToConversations(_ values: NSSet)

    @objc(removeConversations:)
    @NSManaged public func removeFromConversations(_ values: NSSet)

}
