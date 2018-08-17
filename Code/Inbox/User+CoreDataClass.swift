//
//  User+CoreDataClass.swift
//  Inbox
//
//  Created by Amir Akram on 07/08/2017.
//  Copyright © 2017 Amir Akram. All rights reserved.
//

import Foundation
import CoreData

public class User: NSManagedObject {
    
    static func create(context: NSManagedObjectContext, serial:String,uuid:String,isRemember:Bool,token: String, userId: Int64, username: String, formattedUsername: String, email: String, phone: String, mobile: String, firstName: String, lastName: String, companyName: String, address: String, city: String, country: String,state: String, zipCode: String, whiteLableConfigurationId: Int64, userGroupId: Int64, timezone: Int64, license: String) -> User
    {
        var targettedUser:User? = nil
        
        if let user = User.getUserFromID(userName_: username)
        {
            targettedUser = user
            
        } else {
            
            targettedUser = User(context: context)
        }
        
        targettedUser?.serial = serial
        targettedUser?.uuid = uuid
        targettedUser?.isRemember = isRemember
        //
        targettedUser?.token = token
        targettedUser?.userId = userId
        targettedUser?.username = username
        targettedUser?.formattedUsername = formattedUsername
        targettedUser?.email = email
        targettedUser?.phone = phone
        targettedUser?.mobile = mobile
        targettedUser?.firstName = firstName
        targettedUser?.lastName = lastName
        targettedUser?.companyName = companyName
        targettedUser?.address = address
        targettedUser?.city = city
        targettedUser?.country = country
        targettedUser?.state = state
        targettedUser?.zipCode = zipCode
        targettedUser?.whiteLableConfigurationId = whiteLableConfigurationId
        targettedUser?.userGroupId = userGroupId
        targettedUser?.timezone = timezone
        targettedUser?.license = license
        
        return targettedUser!
    }
    
    static func getLoginedUser()-> User?
    {
        return loginedUser
    }
    
    func getConverstaionFromID(conID: Int64) -> Conversation? {
        
        let filteredConversations = self.conversations?.allObjects.filter { ($0 as! Conversation).conversationId == conID }
        
        if (filteredConversations?.count)! > 0 {
            return filteredConversations?.first as? Conversation
        }
        
        return nil;
    }
    
    static func getUserFromID(userName_: String) -> User? {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let predicate = NSPredicate(format: "username == %@", userName_)
        request.predicate = predicate
        request.fetchLimit = 1
        
        do{
            let result = try DEFAULT_CONTEXT.fetch(request) as! Array<User>
            
            if(result.count > 0)
            {
                return result.first
            }
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return nil;
    }
}

//************************************************************************************************//
//------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------//
//************************************************************************************************//

extension User
{
    static func loginWithUser(serial:String, uuid:String, isRemember:Bool, completionBlockSuccess successBlock: @escaping ((User?) -> (Void)), andFailureBlock failureBlock: @escaping ((Error?) -> (Void)))
    {
        var paramsDic = Dictionary<String, Any>()
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
                            
                            self.syncContacts(completionBlockSuccess: { () -> (Void) in
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
                            
                            //
                            //                            self.getLatestConversations(completionBlockSuccess: { (conversations: Array<Conversation>?) -> (Void) in
                            //
                            //
                            //                                }
                            //
                            //                            }, andFailureBlock: { (error: Error?) -> (Void) in
                            //
                            //                                failureBlock(error)
                            //                            })
                    }
            }
            
        }) { (error: Error?) -> (Void) in
            
            failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:WebManager.User_Not_Logined]))
        }
    }
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    static func registerUserAPNS(serial:String, uuid:String, completionBlockSuccess successBlock: @escaping ((Bool) -> (Void)), andFailureBlock failureBlock: @escaping ((Error?) -> (Void)))
    {
        var paramsDic = Dictionary<String, Any>()
        let defaults = UserDefaults.standard
        paramsDic["serial"] = serial
        paramsDic["uuid"] = uuid
        paramsDic["type"] = "Inbox"
        
        if let token = defaults.string(forKey: "pushyToken")
        {
            paramsDic["token"] = token
        }
        
        WebManager.registerAPNS(params: paramsDic, completionBlockSuccess: { (response: Dictionary<String, Any>?) -> (Void) in
            
            successBlock(true)
            
        }) { (error: Error?) -> (Void) in
            
            failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:WebManager.User_Not_Logined]))
        }
    }
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    static func deleteUserAPNS(serial:String, uuid:String, completionBlockSuccess successBlock: @escaping ((Bool) -> (Void)), andFailureBlock failureBlock: @escaping ((Error?) -> (Void)))
    {
        var paramsDic = Dictionary<String, Any>()
        let defaults = UserDefaults.standard
        paramsDic["serial"] = serial
        paramsDic["uuid"] = uuid
        paramsDic["type"] = "Inbox"
        
        if let token = defaults.string(forKey: "pushyToken")
        {
            paramsDic["token"] = token
        }
        
        WebManager.deleteAPNS(params: paramsDic, completionBlockSuccess: { (response: Dictionary<String, Any>?) -> (Void) in
            
            successBlock(true)
            
        }) { (error: Error?) -> (Void) in
            
            failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:WebManager.User_Not_Logined]))
        }
    }
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    static func getLatestConversations(completionBlockSuccess successBlock: @escaping ((Array<Conversation>?) -> (Void)), andFailureBlock failureBlock: @escaping ((Error?) -> (Void)))
    {
        if let user = User.getLoginedUser()
        {
            var paramsDic = Dictionary<String, Any>()
            
            paramsDic["serial"] = user.serial
            paramsDic["uuid"] = user.uuid
            paramsDic["token"] = user.token
            
            WebManager.requestConversations(params:paramsDic, conversationParser: ConversationParser(),completionBlockSuccess:{(conversations:Array<Conversation>?) -> (Void) in
                
                DispatchQueue.global(qos: .background).async
                    {
                        DispatchQueue.main.async
                            {
                                for case let savedConversation as Conversation in user.conversations!
                                {
                                    var isFound = false
                                    
                                    for conversation in conversations!
                                    {
                                        if conversation.conversationId == savedConversation.conversationId
                                        {
                                            isFound = true
                                            
                                            break
                                        }
                                    }
                                    
                                    if isFound == false
                                    {
                                        savedConversation.user = nil
                                    }
                                }
                                
                                for conversation in conversations!
                                {
                                    conversation.user = user
                                }
                                
                                User.getLoginedUser()?.updateConversations()
                                
                                CoreDataManager.coreDataManagerSharedInstance.saveContext()
                                
                                successBlock(user.conversations?.allObjects as? Array<Conversation>)
                        }
                }
                
            }){(error:Error?) -> (Void) in
                
                failureBlock(error)
            }
        }
        else
        {
            failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:WebManager.User_Not_Logined]))
        }
    }
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    static func getMessageForConversation(_ conversation: Conversation, completionBlockSuccess successBlock: @escaping ((Array<Message>?) -> (Void)), andFailureBlock failureBlock: @escaping ((Error?) -> (Void)))
    {
        if let user = User.getLoginedUser()
        {
            var paramsDic = Dictionary<String, Any>()
            
            paramsDic["serial"] = user.serial
            paramsDic["uuid"] = user.uuid
            paramsDic["mobile"] = "1" //conversation.mobile
            paramsDic["shortCode"] = "1" //conversation.shortCode
            
            paramsDic["token"] = user.token
            paramsDic["lastMessageId"] = String(conversation.lastMessageId)
            
            
            WebManager.getMessages(params:paramsDic,messageParser:MessagesParser(conversation),completionBlockSuccess:{(messages:Array<Message>?) -> (Void) in
                
                DispatchQueue.global(qos: .background).async
                    {
                        DispatchQueue.main.async
                            {
                                for message in messages!
                                {
                                    message.conversation = conversation
                                }
                                
                                CoreDataManager.coreDataManagerSharedInstance.saveContext()
                                
                                successBlock(messages)
                        }
                }
                
            }){(error:Error?) -> (Void) in
                
                failureBlock(error)
            }
        }
        else
        {
            failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:WebManager.User_Not_Logined]))
        }
    }
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    static func optOutFromConversation(conversation: Conversation, completionBlockSuccess successBlock: @escaping ((Bool) -> (Void)), andFailureBlock failureBlock: @escaping ((Error?) -> (Void)))
    {
        if let user = User.getLoginedUser()
        {
            var paramsDic = Dictionary<String, Any>()
            paramsDic["serial"] = user.serial
            paramsDic["uuid"] = user.uuid
            paramsDic["mobile"] = "1" //conversation.mobileNumber
            
            WebManager.optOutMessage(params: paramsDic, completionBlockSuccess: { (response) -> (Void) in
                
                if let status = response?["status"] as? String
                {
                    if (status == "OK")
                    {
                        successBlock(true)
                    }
                    else
                    {
                        failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:status]))
                    }
                }
                else if let status = response?["err"] as? String
                {
                    failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:status]))
                }
                else
                {
                    successBlock(false)
                }
                
            }, andFailureBlock: { (error:Error?) -> (Void) in
                failureBlock(error)
            })
        }
        else
        {
            failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:WebManager.User_Not_Logined]))
        }
    }
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    static func sendUserMessage(conversation: Conversation, paramsJson: Dictionary<String,Any>, completionBlockSuccess successBlock: @escaping ((_ messageNew: Message) -> (Void)), andFailureBlock failureBlock: @escaping ((Error?) -> (Void)))
    {
        if let user = User.getLoginedUser()
        {
            var paramsDic = Dictionary<String, Any>()
            
            paramsDic["ev"] = "kioskSendMessage"
            paramsDic["serial"] = user.serial
            paramsDic["uuid"] = user.uuid
            paramsDic["mobile"] = "1" //conversation.mobileNumber
            paramsDic["message"] = paramsJson["message"] as! String
            
            if (paramsJson["message"] as! String != ""){
                paramsDic["message"] = paramsJson["message"] as! String
            }
            if (paramsJson["attachment"] as! String != ""){
                paramsDic["attachment"] = paramsJson["attachment"] as! String
            }
            if (paramsJson["attachmentFileSuffix"] as! String != ""){
                paramsDic["attachmentFileSuffix"] = paramsJson["attachmentFileSuffix"] as! String
            }
            //            if (conversation.shortcodeDisplay == "TollFree") && !(conversation.tollFree == "") {
            //                paramsDic["shortcode"] = conversation.tollFree
            //            } else {
            //                paramsDic["shortcode"] = conversation.shortcodeDisplay
            //            }
            
            WebManager.sendMessage(params: paramsDic, completionBlockSuccess: { (response) -> (Void) in
                
                print("\n ===== >>>>> SEND MESSAGE RESPONSE =  <<<<< ===== \(String(describing: response)) \n")
                
                if let status = response?["result"] as? String
                {
                    let splitString = status.components(separatedBy: ",")
                    
                    if (String(splitString[0]) == "OK")
                    {
                        var msgDate = Date()
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = DATE_FORMATE_STRING
                        let dateString = dateFormatter.string(from: msgDate)
                        msgDate = dateFormatter.date(from: dateString)!
                        
                        DispatchQueue.global(qos: .background).async
                            {
                                DispatchQueue.main.async
                                    {
                                        let msgID: Int64 = Int64(splitString[1])!
                                        
                                        let message = Message() // .create(context: DEFAULT_CONTEXT, date_: msgDate, message_:  paramsJson["message"] as! String, messageId_: msgID, mobile_: conversation.mobile!, shortCode_: conversation.shortCode!, isSender_: true, isRead_: false, updatedOn_: 0, createdOn_: 0)
                                        
                                        conversation.addToMessages(message)
                                        
                                        CoreDataManager.coreDataManagerSharedInstance.saveContext()
                                        
                                        successBlock(message)
                                }
                        }
                    }
                    else
                    {
                        failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:status]))
                    }
                }
                else if let status = response?["err"] as? String
                {
                    failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:status]))
                    
                } else {
                    
                    failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:""]))
                }
            }, andFailureBlock: { (error) -> (Void) in
                failureBlock(error)
            })
            
        }
        else {
            failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:WebManager.User_Not_Logined]))
        }
    }
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    static func composeNewMessage(mobile: String, message: String, completionBlockSuccess successBlock: @escaping ((Bool) -> (Void)), andFailureBlock failureBlock: @escaping ((Error?) -> (Void)))
    {
        if let user = User.getLoginedUser()
        {
            var paramsDic = Dictionary<String, Any>()
            
            paramsDic["serial"] = user.serial
            paramsDic["uuid"] = user.uuid
            paramsDic["mobile"] = mobile
            paramsDic["message"] = message
            
            WebManager.composeMessage(params: paramsDic, completionBlockSuccess: { (response) -> (Void) in
                
                if let status = response?["result"] as? String
                {
                    /////////////////////////////////////////////////////////////////////////////
                    /////////////////////////////////////////////////////////////////////////////
                    /////////////////////////////////////////////////////////////////////////////
                    /////////////////////////////////////////////////////////////////////////////
                    /////////////////////////////////////////////////////////////////////////////
                    let splitString = status.components(separatedBy: ",")
                    
                    if (String(splitString[0]) == "OK") {
                        
                        DispatchQueue.global(qos: .background).async
                            {
                                DispatchQueue.main.async
                                    {
                                        successBlock(true)
                                }
                        }
                    } else {
                        failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:status]))
                    }
                    /////////////////////////////////////////////////////////////////////////////
                    /////////////////////////////////////////////////////////////////////////////
                    /////////////////////////////////////////////////////////////////////////////
                    /////////////////////////////////////////////////////////////////////////////
                    /////////////////////////////////////////////////////////////////////////////
                    
                }
                else if let status = response?["err"] as? String
                {
                    
                    failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:status]))
                    
                } else {
                    
                    failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:""]))
                }
            }, andFailureBlock: { (error) -> (Void) in
                failureBlock(error)
            })
            
        }
        else {
            failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:WebManager.User_Not_Logined]))
        }
    }
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    static func createAppointment(params: Dictionary<String,Any>, completionBlockSuccess successBlock: @escaping ((Bool) -> (Void)), andFailureBlock failureBlock: @escaping ((Error?) -> (Void)))
    {
        if let user = User.getLoginedUser()
        {
            var paramsDic = Dictionary<String, Any>()
            
            paramsDic["uuid"] = user.uuid
            paramsDic["serial"] = user.serial
            paramsDic["mobile"] = WebManager.removeSpecialCharsFromString(params["mobile"] as! String)
            paramsDic["message"] = params["message"]
            paramsDic["date"] = params["date"]
            paramsDic["type"] = params["type"]
            paramsDic["notifyHours"] = params["notifyHours"] as! String
            
            //            paramsDic["first"] = params["first"] as! String
            //            paramsDic["last"] = params["last"] as! String
            //            paramsDic["endDate"] = "" //params["endDate"] as! String
            //            paramsDic["notifyEmail"] = "" //params["notifyEmail"] as! String
            //            paramsDic["notifyNumber"] = "" //params["notifyNumber"] as! String
            
            WebManager.createAppointment(params: paramsDic, completionBlockSuccess: { (response) -> (Void) in
                
                if let status = response?["status"] as? String
                {
                    /////////////////////////////////////////////////////////////////////////////
                    /////////////////////////////////////////////////////////////////////////////
                    let splitString = status.components(separatedBy: ",")
                    
                    if (String(splitString[0]) == "OK") {
                        
                        DispatchQueue.global(qos: .background).async
                            {
                                DispatchQueue.main.async
                                    {
                                        successBlock(true)
                                }
                        }
                    } else {
                        failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:status]))
                    }
                    /////////////////////////////////////////////////////////////////////////////
                    /////////////////////////////////////////////////////////////////////////////
                    /////////////////////////////////////////////////////////////////////////////
                    /////////////////////////////////////////////////////////////////////////////
                    /////////////////////////////////////////////////////////////////////////////
                    
                }
                else if let status = response?["err"] as? String
                {
                    
                    failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:status]))
                    
                } else {
                    
                    failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:""]))
                }
            }, andFailureBlock: { (error) -> (Void) in
                failureBlock(error)
            })
            
        }
        else {
            failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:WebManager.User_Not_Logined]))
        }
    }
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    static func setReadConversation(conversation: Conversation, completionBlockSuccess successBlock: @escaping ((Bool) -> (Void)), andFailureBlock failureBlock: @escaping ((Error?) -> (Void)))
    {
        
        if let user = User.getLoginedUser()
        {
            var paramsDic = Dictionary<String, Any>()
            
            paramsDic["serial"] = user.serial
            paramsDic["uuid"] = user.uuid
            paramsDic["mobile"] = "1" //conversation.mobile
            paramsDic["shortCode"] = "1" //conversation.shortCode
            
            WebManager.setReadReceipt(params: paramsDic, completionBlockSuccess: { (response) -> (Void) in
                
                DispatchQueue.global(qos: .background).async
                    {
                        DispatchQueue.main.async
                            {
                                
                                if let status = response?["status"] as? String
                                {
                                    if (status == "OK")
                                    {
                                        successBlock(true)
                                        
                                    } else  {
                                        failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:status]))
                                    }
                                    
                                } else if let status = response?["err"] as? String{
                                    
                                    print(status)
                                    
                                    failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:status]))
                                } else {
                                    successBlock(false)
                                }
                        }
                }
                
            }, andFailureBlock: { (error:Error?) -> (Void) in
                failureBlock(error)
            })
            
        }
        else
        {
            failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:WebManager.User_Not_Logined]))
        }
    }
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    
    static func setReadAllConversations(conversations: NSSet,index:Int, completionBlockSuccess successBlock: @escaping ((Bool) -> (Void)), andFailureBlock failureBlock: @escaping ((Error?) -> (Void)))
    {
        if let user = User.getLoginedUser()
        {
            if index >= 0 && index < conversations.count
            {
                let conversation = conversations.allObjects[index] as! Conversation
                
                if conversation.unreadMessages == false
                {
                    User.setReadAllConversations(conversations: conversations, index: index + 1, completionBlockSuccess: successBlock, andFailureBlock: failureBlock)
                }
                else
                {
                    var paramsDic = Dictionary<String, Any>()
                    
                    paramsDic["serial"] = user.serial
                    paramsDic["uuid"] = user.uuid
                    paramsDic["mobile"] = "1" //conversation.mobile
                    paramsDic["shortCode"] = "1"// conversation.shortCode
                    
                    WebManager.setReadReceipt(params: paramsDic, completionBlockSuccess: { (response) -> (Void) in
                        
                        DispatchQueue.global(qos: .background).async
                            {
                                DispatchQueue.main.async
                                    {
                                        if let status = response?["status"] as? String
                                        {
                                            if (status == "OK")
                                            {
                                                conversation.unreadMessages = false
                                                
                                                User.setReadAllConversations(conversations: conversations, index: index + 1, completionBlockSuccess: successBlock, andFailureBlock: failureBlock)
                                            }
                                            else
                                            {
                                                failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:status]))
                                            }
                                            
                                        } else if let status = response?["err"] as? String
                                        {
                                            failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:status]))
                                        }
                                        else
                                        {
                                            failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:"Unable to mark all conversations as read due connectivity issue"]))
                                        }
                                }
                        }
                        
                    }, andFailureBlock: { (error:Error?) -> (Void) in
                        failureBlock(error)
                    })
                }
            }
            else
            {
                CoreDataManager.coreDataManagerSharedInstance.saveContext()
                
                successBlock(true)
            }
        }
        else
        {
            failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:WebManager.User_Not_Logined]))
        }
    }
    
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    static func deleteLocalConversation(conversation: Conversation, completionBlockSuccess successBlock: @escaping ((Bool) -> (Void)), andFailureBlock failureBlock: @escaping ((Error?) -> (Void)))
    {
        
        if let user = User.getLoginedUser()
        {
            var paramsDic = Dictionary<String, Any>()
            
            paramsDic["serial"] = user.serial
            paramsDic["uuid"] = user.uuid
            paramsDic["mobile"] = "1" //conversation.mobile
            paramsDic["shortCode"] = "1" //conversation.shortCode
            
            WebManager.deleteConversation(params: paramsDic, completionBlockSuccess: { (response) -> (Void) in
                
                DispatchQueue.global(qos: .background).async
                    {
                        DispatchQueue.main.async
                            {
                                if let status = response?["status"] as? String
                                {
                                    if (status == "OK")
                                    {
                                        User.getLoginedUser()?.removeFromConversations(conversation)
                                        
                                        do {
                                            
                                            try user.managedObjectContext?.save()
                                        }
                                        catch {
                                            
                                        }
                                        
                                        CoreDataManager.coreDataManagerSharedInstance.saveContext()
                                        
                                        successBlock(true)
                                        
                                    } else  {
                                        failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:status]))
                                    }
                                    
                                } else if let status = response?["err"] as? String {
                                    
                                    failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:status]))
                                } else {
                                    successBlock(false)
                                }
                        }
                }
                
            }, andFailureBlock: { (error:Error?) -> (Void) in
                failureBlock(error)
            })
        }
        else
        {
            failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:WebManager.User_Not_Logined]))
        }
    }
    
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    static func syncContacts(completionBlockSuccess successBlock: @escaping (() -> (Void)), andFailureBlock failureBlock: @escaping ((Error?) -> (Void)))
    {
        
        if let user = User.getLoginedUser()
        {
            var paramsDic = Dictionary<String, Any>()
            paramsDic["token"] = user.token
            
            //(params:paramsDic, conversationParser: ConversationParser(),completionBlockSuccess:{(conversations:Array<Conversation>?) -> (Void) in
            
            WebManager.getAllContacs(params: paramsDic, contactParser: UserContactsParser(), completionBlockSuccess:{(response:Array<UserContact>?) -> (Void) in
                
                DispatchQueue.global(qos: .background).async
                    {
                        DispatchQueue.main.async
                            {
                                self.getLatestConversations(completionBlockSuccess: { (conversations: Array<Conversation>?) -> (Void) in
                                    
                                    DispatchQueue.global(qos: .background).async
                                        {
                                            DispatchQueue.main.async
                                                {
                                                    CoreDataManager.coreDataManagerSharedInstance.saveContext()
                                                    
                                                    successBlock()
                                            }
                                    }
                                    
                                }, andFailureBlock: { (error: Error?) -> (Void) in
                                    
                                    failureBlock(error)
                                })
                        }
                    }.self
                
            }) { (error: Error?) -> (Void) in
                
                failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:WebManager.User_Not_Logined]))
            }
        }
        else
        {
            failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:WebManager.User_Not_Logined]))
        }
    }
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    @discardableResult
    func updateConversations() -> Bool
    {
        // Fetch all conversations
        // Fetch All UserContacts
        
        let user = User.getLoginedUser()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserContact")
        
        do
        {
            let results = try self.managedObjectContext?.fetch(fetchRequest)
            
            let  contracts = results as! [UserContact]
            
            if let chats =  user?.conversations?.allObjects as? Array<Conversation>
            {
                for conv in chats
                {
                    for contact in contracts
                    {
                        if conv.senderId == contact.contactId
                        {
                            conv.sender = contact
                        }
                        
                        if conv.contactId == contact.contactId
                        {
                            conv.receiver = contact
                        }
                    }
                }
            }
            
        } catch let error as NSError {
            //            print("Could not fetch \(error)”)
        }
        
        return true
    }
}
