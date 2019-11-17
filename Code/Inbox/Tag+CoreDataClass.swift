import Foundation
import CoreData

public class Tag: NSManagedObject
{
    static func getTagFromID(tagID: Int64) -> Tag?
    {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Tag")
        
        let predicate = NSPredicate(format: "tagId == %d", tagID)
        
        request.predicate = predicate
        
        request.fetchLimit = 1
        
        do
        {
            let result = try DEFAULT_CONTEXT.fetch(request) as! Array<Tag>
            
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
    
    static func getAllTags() -> Array<Tag>
    {
       let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Tag")
       
       do
       {
           let result = try DEFAULT_CONTEXT.fetch(request) as! Array<Tag>
           
           return result
       }
       catch let error as NSError
       {
           print("Could not fetch \(error), \(error.userInfo)")
       }
       
       return Array<Tag>()
    }
}

extension Tag
{
     static func create(context: NSManagedObjectContext, tagName_: String, tagId_: Int64) -> Tag
     {
        let tag = Tag(context: context)
        
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

extension Tag
{
    static func syncTags(completionBlockSuccess successBlock:@escaping (() -> (Void)), andFailureBlock failureBlock:@escaping ((Error?) -> (Void)))
    {
        Tag.getAllTagsAPI(completionBlockSuccess: { (tags:Array<Tag>) -> (Void) in
            
            Tag.getContactsTags(completionBlockSuccess: { (contactTags:Array<ContactTag>) -> (Void) in
                
                UserContact.getAllContacts(completionBlockSuccess: { (contacts:Array<UserContact>) -> (Void) in
                      
                    let doesContactsMerged = ContactTagMerger.merge(contacts:contacts, tags:tags, contactTags:contactTags)
                    
                    if doesContactsMerged == true
                    {
                        DispatchQueue.global(qos: .background).async
                        {
                            DispatchQueue.main.async
                            {
                                CoreDataManager.coreDataManagerSharedInstance.saveContext()
                                
                                successBlock()
                            }
                        }
                    }
                    else
                    {
                        failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:WebManager.Contacts_Syncing_Error]))
                    }
                                        
                }, andFailureBlock:failureBlock)
                
            }, andFailureBlock:failureBlock)
            
        }, andFailureBlock: failureBlock)
    }
    
    static func getAllTagsAPI(completionBlockSuccess successBlock:@escaping ((_ tagsArray:Array<Tag>) -> (Void)), andFailureBlock failureBlock:@escaping ((Error?) -> (Void)))
    {
        if let user = User.getLoginedUser()
        {
            var paramsDic = Dictionary<String, Any>()
            
            paramsDic["token"] = user.token
            
            WebManager.getAllTags(params:paramsDic, tagsParser:TagParser(), completionBlockSuccess:successBlock, andFailureBlock:failureBlock)
        }
        else
        {
            failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:WebManager.User_Not_Logined]))
        }
    }
    
    static func getContactsTags(completionBlockSuccess successBlock:@escaping ((Array<ContactTag>) -> (Void)), andFailureBlock failureBlock:@escaping ((Error?) -> (Void)))
    {
        if let user = User.getLoginedUser()
        {
            var paramsDic = Dictionary<String, Any>()
            
            paramsDic["token"] = user.token
                        
            WebManager.getContactsTags(params:paramsDic, contactTagsParser:ContactTagParser(), completionBlockSuccess: successBlock, andFailureBlock: failureBlock)
        }
        else
        {
            failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:WebManager.User_Not_Logined]))
        }
    }

    static func createTagAPI(tagName:String, contacts:Array<UserContact>, completionBlockSuccess successBlock: @escaping ((Bool) -> (Void)), andFailureBlock failureBlock: @escaping ((Error?) -> (Void)))
    {
        if let user = User.getLoginedUser()
        {
            var paramsDic = Dictionary<String, Any>()
            
            paramsDic["token"] = user.token
            
            if (tagName != "")
            {
                paramsDic["tagName"] = tagName
            }
            
            //if (autoResponse != "")
            //{
                //paramsDic["autoResponse"] = autoResponse
            //}
                            
                WebManager.createTag(params: paramsDic, completionBlockSuccess: { (response) -> (Void) in
                                    
                var tempDictionary = Dictionary<String,Any>()
                let jsonDict: Dictionary<String, Any> = response!
                
                if jsonDict["statusCode"] != nil {
                    tempDictionary["name"] = jsonDict["name"] as! String
                    tempDictionary["errorCode"] = jsonDict["errorCode"] as! Int
                    tempDictionary["message"] = jsonDict["message"] as! String
                    tempDictionary["errorCode"] = jsonDict["statusCode"] as! Int
                    
                    let messageStr =  tempDictionary["message"] as! String
                    
                    failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:messageStr]))
                }
                else
                {
                    DispatchQueue.global(qos: .background).async
                    {
                        DispatchQueue.main.async
                        {
                            let tagId = jsonDict["id"] as! Int64
                            
                            let tag = Tag.create(context:DEFAULT_CONTEXT, tagName_:tagName, tagId_:tagId)

                            CoreDataManager.coreDataManagerSharedInstance.saveContext()

                            UserContact.assignTagToContacts(tag:tag, contacts:contacts, completionBlockSuccess:successBlock, andFailureBlock:failureBlock)
                        }
                    }
                }
            }, andFailureBlock:failureBlock)
        }
        else
        {
            failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:WebManager.User_Not_Logined]))
        }
    }
    
    static func deleteTag(tagToDelete:Tag, completionBlockSuccess successBlock: @escaping ((Bool) -> (Void)), andFailureBlock failureBlock: @escaping ((Error?) -> (Void)))
    {
        if let user = User.getLoginedUser()
        {
            var paramsDic = Dictionary<String, Any>()
            
            paramsDic["token"] = user.token
            
            paramsDic["tagId"] = String(tagToDelete.tagId)

            WebManager.deleteTags(params: paramsDic, completionBlockSuccess: { (response) -> (Void) in
                                    
                var tempDictionary = Dictionary<String,Any>()
                
                let jsonDict: Dictionary<String, Any> = response!
                
                if jsonDict["statusCode"] != nil
                {
                    tempDictionary["name"] = jsonDict["name"] as! String
                    tempDictionary["errorCode"] = jsonDict["errorCode"] as! Int
                    tempDictionary["message"] = jsonDict["message"] as! String
                    tempDictionary["errorCode"] = jsonDict["statusCode"] as! Int
                    
                    let messageStr =  tempDictionary["message"] as! String
                    
                    if (jsonDict["errorCode"] as! Int == 200) {

                        successBlock(true)
                    }
                    else {
                        failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:messageStr]))
                    }
                    
                }
                else
                {
                    DispatchQueue.global(qos: .background).async
                    {
                        DispatchQueue.main.async
                        {
                            tagToDelete.managedObjectContext?.delete(tagToDelete)
                            
                            CoreDataManager.coreDataManagerSharedInstance.saveContext()
                        }
                    }
                }
            }, andFailureBlock:failureBlock)
        }
        else
        {
            failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:WebManager.User_Not_Logined]))
        }
    }
}

