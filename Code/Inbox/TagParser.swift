import Foundation

class TagParser: NSObject
{
    func parseAllTags(json:Dictionary<String,Any>)-> Array<Tag>
    {
        var tagsListFinal = Array<Tag>()
        
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
                        var tag: Tag? = Tag.getTagFromID(tagID:tag_ID)
                        
                        if tag == nil
                        {
                            tag = Tag.create(context:DEFAULT_CONTEXT, tagName_:tagName, tagId_:tag_ID)
                        }
                        else
                        {
                            tag?.update(tagName_:tagName, tagId_:tag_ID)
                        }

                        tagsListFinal.append(tag!)
                    }
                }
            }
        }
        
        return tagsListFinal
    }
}
