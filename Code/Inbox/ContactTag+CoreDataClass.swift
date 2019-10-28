import Foundation
import CoreData

public class ContactTag: NSManagedObject
{
    static func getContactTagFromID(tagID: Int64) -> ContactTag?
    {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ContactTag")
        
        let predicate = NSPredicate(format: "tagId == %d", tagID)
        
        request.predicate = predicate
        
        request.fetchLimit = 1
        
        do
        {
            let result = try DEFAULT_CONTEXT.fetch(request) as! Array<ContactTag>
            
            if(result.count > 0)
            {
                return result.first
            }
        }
        catch let error as NSError
        {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return nil;
    }
}

extension ContactTag
{
     static func create(context: NSManagedObjectContext, tagName_: String, tagId_: Int64) -> ContactTag
     {
        let tag = ContactTag(context: context)
        
        tag.tagId = tagId_
        
        tag.tagName = tagName_
        
        return tag
    }
    
    func update(tagName_: String, tagId_: Int64)
    {
        self.tagId = tagId_
        
        self.tagName = tagName_
    }
}

extension ContactTag
{
    static func getAllTags(completionBlockSuccess successBlock:@escaping ((Array<ContactTag>?) -> (Void)), andFailureBlock failureBlock:@escaping ((Error?) -> (Void)))
    {
        WebManager.getAllTags(params: <#T##Dictionary<String, Any>#>, tagsParser: <#T##ContactTagParser#>, completionBlockSuccess: <#T##((Array<ContactTag>?) -> (Void))##((Array<ContactTag>?) -> (Void))##(Array<ContactTag>?) -> (Void)#>, andFailureBlock: <#T##((Error?) -> (Void))##((Error?) -> (Void))##(Error?) -> (Void)#>)
        
    }
}

