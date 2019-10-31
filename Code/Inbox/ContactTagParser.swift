import Foundation

class ContactTagParser: NSObject
{
    func parseContactTag(json:Dictionary<String,Any>)-> Array<ContactTag>
    {
        var contactTagsArr = Array<ContactTag>()
        
        var tempDictionary = Dictionary<String,Any>()
        
        if json["statusCode"] != nil
        {
            tempDictionary["name"] = json["name"] as! String
            
            tempDictionary["errorCode"] = json["errorCode"] as! Int64
            
            tempDictionary["message"] = json["message"] as! String
            
            tempDictionary["statusCode"] = json["statusCode"] as! Int64
        }
        else
        {
            let tagsArray = json["tagsContacts"] as! Array<Dictionary<String,Any>>
            
            for dic in tagsArray
            {
                if let tagId = dic["contactId"] as? Int64
                {
                    if let contactId = dic["contactId"] as? Int64
                    {
                        let contactTag = ContactTag.init(contactId_:contactId, tagId_:tagId)

                        contactTagsArr.append(contactTag)
                    }
                }
            }
        }
        
        return contactTagsArr
    }
}
