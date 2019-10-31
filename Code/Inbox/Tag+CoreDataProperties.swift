import Foundation
import CoreData

extension Tag
{
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tag>
    {
        return NSFetchRequest<Tag>(entityName: "Tag")
    }

    @NSManaged public var tagId: Int64
    @NSManaged public var tagName: String?
    @NSManaged public var userContacts: NSSet?
}

extension Tag
{
    @objc(addUserContactsObject:)
    @NSManaged public func addToUserContacts(_ value: UserContact)

    @objc(removeUserContactsObject:)
    @NSManaged public func removeFromUserContacts(_ value: UserContact)

    @objc(addUserContacts:)
    @NSManaged public func addToUserContacts(_ values: NSSet)

    @objc(removeUserContacts:)
    @NSManaged public func removeFromUserContacts(_ values: NSSet)
}

