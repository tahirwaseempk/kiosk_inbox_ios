import Foundation

class ContactTagMerger: NSObject
{
    static func merge(contacts:Array<UserContact>, tags:Array<Tag>, contactTags:Array<ContactTag>) -> Bool
    {
        for contact in contacts
        {
            contact.tags = NSSet()
        }
        
        for contact in contacts
        {
            for contactTagMango in contactTags
            {
                if contactTagMango.contactId == contact.contactId
                {
                    for tag in tags
                    {
                       // print(tag.tagId)

                        if tag.tagId == contactTagMango.tagId
                        {
                            contact.addToTags(tag)
                            
                            tag.addToUserContacts(contact)
                            
                            break
                        }
                    }
                }
            }
        }
        
        return true
    }
}
