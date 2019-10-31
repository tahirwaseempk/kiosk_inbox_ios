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
            for contactTag in contactTags
            {
                if contactTag.contactId == contact.contactId
                {
                    for tag in tags
                    {
                        if tag.tagId == contactTag.tagId
                        {
                            contact.addToTags(tag)
                            
                            break
                        }
                    }
                    
                    break;
                }
            }
        }
        
        return true
    }
}
