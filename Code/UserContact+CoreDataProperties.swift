import Foundation
import CoreData

extension UserContact
{
    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserContact>
    {
        return NSFetchRequest<UserContact>(entityName: "UserContact")
    }

    @NSManaged public var user: User?
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
    @objc(addTagsObject:)
    @NSManaged public func addToTags(_ value: Tag)

    @objc(removeTagsObject:)
    @NSManaged public func removeFromTags(_ value: Tag)

    @objc(addTags:)
    @NSManaged public func addToTags(_ values: NSSet)

    @objc(removeTags:)
    @NSManaged public func removeFromTags(_ values: NSSet)
}
