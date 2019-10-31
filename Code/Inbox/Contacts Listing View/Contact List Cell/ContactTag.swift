import UIKit

class ContactTag: NSObject
{
    var contactId:Int64 = 0
    var tagId:Int64 = 0
    
    init(contactId_:Int64, tagId_:Int64)
    {
        super.init()
        
        self.contactId = contactId_
        
        self.tagId = tagId_
    }
}
