import Foundation
import CoreData

extension UserContact
{
    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserContact>
    {
        return NSFetchRequest<UserContact>(entityName: "UserContact")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var gender: String?
    @NSManaged public var country: String?
    @NSManaged public var zipCode: String?
    @NSManaged public var address: String?
    @NSManaged public var city: String?
    @NSManaged public var state: String?
    @NSManaged public var birthDate: Date?
    @NSManaged public var email: String?
    @NSManaged public var contactId: Int64
    @NSManaged public var tags: NSSet?
}

extension UserContact
{
    @objc(addContactTagsObject:)
    @NSManaged public func addToContactTags(_ value: ContactTag)

    @objc(removeContactTagsObject:)
    @NSManaged public func removeFromContactTags(_ value: ContactTag)

    @objc(addContactTags:)
    @NSManaged public func addToContactTags(_ values: NSSet)

    @objc(removeContactTags:)
    @NSManaged public func removeFromContactTags(_ values: NSSet)
}
