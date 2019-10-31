import Foundation
import CoreData

public class UserContact: NSManagedObject
{
    static func getContactFromID(conID: Int64) -> UserContact?
    {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserContact")
        
        let predicate = NSPredicate(format: "contactId == %d", conID)
        
        request.predicate = predicate
        
        request.fetchLimit = 1
        
        do
        {
            let result = try DEFAULT_CONTEXT.fetch(request) as! Array<UserContact>
            
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

extension UserContact
{
    static func create(context: NSManagedObjectContext, firstName_: String, lastName_: String, phoneNumber_: String, gender_: String, country_: String, zipCode_: String, address_: String, city_: String, state_: String, birthDate_: Date, email_: String, contactId_: Int64) -> UserContact
     {
         let contact = UserContact(context: context)
         
         contact.firstName = firstName_
         contact.lastName = lastName_
         contact.phoneNumber = phoneNumber_
         contact.gender = gender_
         contact.country = country_
         contact.zipCode = zipCode_
         contact.address = address_
         contact.city = city_
         contact.state = state_
         contact.birthDate = birthDate_
         contact.email = email_
         contact.contactId = contactId_
         
         return contact
     }

     func update(firstName_: String,lastName_: String, phoneNumber_: String, gender_: String, country_: String, zipCode_: String, address_: String, city_: String, state_: String, birthDate_: Date, email_: String, contactId_: Int64)
     {
         
         self.firstName = firstName_
         self.lastName = lastName_
         self.phoneNumber = phoneNumber_
         self.gender = gender_
         self.country = country_
         self.zipCode = zipCode_
         self.address = address_
         self.city = city_
         self.state = state_
         self.birthDate = birthDate_
         self.email = email_
         self.contactId = contactId_
         
     }

     
    static func updateTags(context: NSManagedObjectContext, cTags_:NSSet) -> UserContact
    {
        let contact = UserContact(context: context)
         
        contact.tags = cTags_
         
        return contact
    }
     
     
    static func getAllContacts(completionBlockSuccess successBlock:@escaping ((Array<UserContact>) -> (Void)), andFailureBlock failureBlock:@escaping ((Error?) -> (Void)))
    {
        if let user = User.getLoginedUser()
        {
            var paramsDic = Dictionary<String, Any>()
            
            paramsDic["token"] = user.token
                       
            WebManager.getAllContacs(params: paramsDic, contactParser:UserContactsParser(), completionBlockSuccess: successBlock, andFailureBlock:failureBlock)
        }
        else
        {
            failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:WebManager.User_Not_Logined]))
        }
    }
}
