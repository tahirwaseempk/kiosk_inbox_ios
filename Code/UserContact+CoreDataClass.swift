//
//  UserContact+CoreDataClass.swift
//  Inbox
//
//  Created by Amir Akram on 12/08/2018.
//  Copyright © 2018 Amir Akram. All rights reserved.
//
//

import Foundation
import CoreData

@objc(UserContact)
public class UserContact: NSManagedObject
{
    
    static func syncContacts(completionBlockSuccess successBlock: @escaping ((Array<UserContact>?) -> (Void)), andFailureBlock failureBlock: @escaping ((Error?) -> (Void)))
    {
        /*var paramsDic = Dictionary<String, Any>()
        paramsDic["serial"] = serial
        paramsDic["uuid"] = uuid
        
        WebManager.requestLogin(params: paramsDic, loginParser: LoginParser(), completionBlockSuccess: { (response: Dictionary<String, Any>?) -> (Void) in
            
            DispatchQueue.global(qos: .background).async
                {
                    DispatchQueue.main.async
                        {
                            
                            let tempDict = response
                            
                            let user :User? = User.create(context: DEFAULT_CONTEXT,
                                                          serial:serial,
                                                          uuid:uuid,
                                                          isRemember:isRemember,
                                                          token: tempDict!["token"] as! String,
                                                          userId: tempDict!["userId"] as! Int64,
                                                          username: response!["username"] as! String,
                                                          formattedUsername: tempDict!["formattedUsername"] as! String,
                                                          email: tempDict!["email"] as! String,
                                                          phone: tempDict!["phone"] as! String,
                                                          mobile: tempDict!["mobile"] as! String,
                                                          firstName: tempDict!["firstName"] as! String,
                                                          lastName: tempDict!["lastName"] as! String,
                                                          companyName: tempDict!["companyName"] as! String,
                                                          address: tempDict!["address"] as! String,
                                                          city: tempDict!["city"] as! String,
                                                          country: tempDict!["country"] as! String,
                                                          state: tempDict!["state"] as! String,
                                                          zipCode: tempDict!["zipCode"] as! String,
                                                          whiteLableConfigurationId: tempDict!["whiteLableConfigurationId"] as! Int64,
                                                          userGroupId: tempDict!["userGroupId"] as! Int64,
                                                          timezone: tempDict!["timezone"] as! Int64,
                                                          license: tempDict!["license"] as! String)
                            
                            User.loginedUser = user
                            
                            self.getLatestConversations(completionBlockSuccess: { (conversations: Array<Conversation>?) -> (Void) in
                                
                                DispatchQueue.global(qos: .background).async
                                    {
                                        DispatchQueue.main.async
                                            {
                                                CoreDataManager.coreDataManagerSharedInstance.saveContext()
                                                
                                                successBlock(user)
                                        }
                                }
                                
                            }, andFailureBlock: { (error: Error?) -> (Void) in
                                
                                failureBlock(error)
                            })
                    }
            }
            
        }) { (error: Error?) -> (Void) in
            
            failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:WebManager.User_Not_Logined]))
        } */
    }
}
