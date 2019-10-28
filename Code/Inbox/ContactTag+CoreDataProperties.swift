import Foundation
import CoreData

extension ContactTag
{
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ContactTag>
    {
        return NSFetchRequest<ContactTag>(entityName: "ContactTag")
    }

    @NSManaged public var tagId: Int64
    @NSManaged public var tagName: String?
    @NSManaged public var userContact: NSSet?
}

extension ContactTag
{
    @objc(addUserContactsObject:)
    @NSManaged public func addToUserContacts(_ value: UserContact)

    @objc(removeUserContactsObject:)
    @NSManaged public func removeFromUserContacts(_ value: UserContact)

    @objc(addUserContacts:)
    @NSManaged public func addToUserContacts(_ values: NSSet)

    @objc(removeUserContacts:)
    @NSManaged public func removeFromContactTags(_ values: NSSet)
}
