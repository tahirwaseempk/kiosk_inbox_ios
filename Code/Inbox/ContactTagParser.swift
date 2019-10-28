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
            let tagsArray = json["tags"] as! Array<Dictionary<String,Any>>
            
            for dic in tagsArray
            {
                if let tagId = dic["id"], let tag_ID = tagId as? Int64
                {
                    if let tagName = dic["name"] as? String
                    {
                        var contactTag: ContactTag? = ContactTag.getContactTagFromID(tagID:tag_ID)
                        
                        if contactTag == nil
                        {
                            contactTag = ContactTag.create(context:DEFAULT_CONTEXT, tagName_:tagName, tagId_:tag_ID)
                        }
                        else
                        {
                            contactTag?.update(tagName_:tagName, tagId_:tag_ID) 
                        }

                        contactTagsArr.append(contactTag!)
                    }
                }
            }
        }
        
        return contactTagsArr
    }
}
