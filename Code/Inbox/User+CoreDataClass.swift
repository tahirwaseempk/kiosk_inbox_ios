//
//  User+CoreDataClass.swift
//  Inbox
//
//  Created by Amir Akram on 07/08/2017.
//  Copyright © 2017 Amir Akram. All rights reserved.
//

import Foundation
import UIKit

import CoreData

public class User: NSManagedObject {
    
    static func create(context: NSManagedObjectContext, isRemember:Bool,token: String, userId: Int64, username: String, formattedUsername: String, email: String, phone: String, mobile: String, firstName: String, lastName: String, companyName: String, address: String, city: String, country: String,state: String, zipCode: String, whiteLableConfigurationId: Int64, userGroupId: Int64, timezone: Int64, license: String) -> User
    {
        var targettedUser:User? = nil
        
        if let user = User.getUserFromID(userId_: userId)
        {
            targettedUser = user
            
        } else {
            
            targettedUser = User(context: context)
        }
        
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
    
    func update(firstName_: String, lastName_: String, email_: String, mobile_: String,companyName_: String, address_: String, city_: String, country_: String, state_: String, zipCode_: String)
    {
        self.firstName = firstName_
        self.lastName = lastName_
        self.email = email_
        self.mobile = mobile_
        self.companyName = companyName_
        self.address = address_
        self.city = city_
        self.country = country_
        self.state = state_
        self.zipCode = zipCode_
    }
    
    func updateMobile(mobile_: String)
    {
        self.mobile = mobile_
    }
    
    static func getLoginedUser()-> User?
    {
        return loginedUser
    }
    
    func logOutUser() -> Bool {
        
        User.loginedUser = nil
        return true
    }
    
    func getConverstaionFromID(chatID_: Int64) -> Conversation? {
        
        let filteredConversations = self.conversations?.allObjects.filter { ($0 as! Conversation).chatId == chatID_ }
        
        if (filteredConversations?.count)! > 0 {
            return filteredConversations?.first as? Conversation
        }
        
        return nil;
    }
    
    static func getUserFromID(userId_: Int64) -> User? {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let predicate = NSPredicate(format: "userId == %d", userId_)
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
    static func loginWithUser(username:String, password:String, isRemember:Bool, completionBlockSuccess successBlock: @escaping ((User?) -> (Void)), andFailureBlock failureBlock: @escaping ((Error?) -> (Void)))
    {
        var paramsDic = Dictionary<String, Any>()
        paramsDic["username"] = username
        paramsDic["password"] = password
        
        WebManager.requestLogin(params: paramsDic, loginParser: LoginParser(), completionBlockSuccess: { (response: Dictionary<String, Any>?) -> (Void) in
            
            DispatchQueue.global(qos: .background).async
                {
                    DispatchQueue.main.async
                        {
                            let tempDict = response
                            
                            if tempDict!["statusCode"] != nil {
                
                                failureBlock(NSError(domain:"com.inbox.amir",code:401,userInfo:[NSLocalizedDescriptionKey:tempDict!["message"] as! String]))
                                
                            } else {
                                
                                let user :User? = User.create(context: DEFAULT_CONTEXT,
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
                                
                            }
                    }
            }
            
        }) { (error: Error?) -> (Void) in
            
            failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:WebManager.User_Not_Logined]))
        }
    }
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    static func registerUserAPNS(license:String, completionBlockSuccess successBlock: @escaping ((Bool) -> (Void)), andFailureBlock failureBlock: @escaping ((Error?) -> (Void)))
    {
        
        if let user = User.getLoginedUser()
        {
            var paramsDic = Dictionary<String, Any>()
            
            paramsDic["token"] = user.token
            
            //----------------------------------------------------//
            #if targetEnvironment(simulator)
            print(" ========== >>>>>>>>>> SIMULATOR <<<<<<<<<< ==========")
            #endif
            //----------------------------------------------------//
            
            WebManager.registerAPNS(params: paramsDic, completionBlockSuccess: { (response: Dictionary<String, Any>?) -> (Void) in
                
                successBlock(true)
                
            }) { (error: Error?) -> (Void) in
                
                failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:WebManager.User_Not_Logined]))
            }
        }
        else {
            failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:WebManager.User_Not_Logined]))
        }
    }
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    static func deleteUserAPNS(serial:String, uuid:String, completionBlockSuccess successBlock: @escaping ((Bool) -> (Void)), andFailureBlock failureBlock: @escaping ((Error?) -> (Void)))
    {
        
        if let user = User.getLoginedUser()
        {
            var paramsDic = Dictionary<String, Any>()

            paramsDic["token"] = user.token
            
            //----------------------------------------------------//
            #if targetEnvironment(simulator)
            print(" ========== >>>>>>>>>> SIMULATOR <<<<<<<<<< ==========")
            #endif
            //----------------------------------------------------//
            
            WebManager.deleteAPNS(params: paramsDic, completionBlockSuccess: { (response: Dictionary<String, Any>?) -> (Void) in
                
              _ = user.logOutUser()
                successBlock(true)
                
            }) { (error: Error?) -> (Void) in
              
              _ =  user.logOutUser()

            failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:WebManager.User_Not_Logined]))
            }
        }
        else {
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
                                        if conversation.chatId == savedConversation.chatId
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
                                
                                // UPDATE ALL CONVERSATIONS CONTACTS//
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
    static func getMessageForConversation(conversation: Conversation, lastMessageId: String, completionBlockSuccess successBlock: @escaping ((Array<Message>?) -> (Void)), andFailureBlock failureBlock: @escaping ((Error?) -> (Void)))
    {
        if let user = User.getLoginedUser()
        {
            var paramsDic = Dictionary<String, Any>()
            paramsDic["token"] = user.token
            paramsDic["chatID"] = String(conversation.chatId)
            
            if (lastMessageId != "") {
                paramsDic["lastMessageID"] = lastMessageId
                WebManager.getMessagesPagination(params:paramsDic,messageParser:MessagesParser(conversation),completionBlockSuccess:{(messages:Array<Message>?) -> (Void) in
                    
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
                
            } else {
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
        /*
        if let user = User.getLoginedUser()
        {
            var paramsDic = Dictionary<String, Any>()
            
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
 */
    }
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    static func sendUserMessage(conversation: Conversation, paramsJson: Dictionary<String,Any>, completionBlockSuccess successBlock: @escaping ((_ messageNew: Message) -> (Void)), andFailureBlock failureBlock: @escaping ((Error?) -> (Void)))
    {
        if let user = User.getLoginedUser()
        {
            var paramsDic = Dictionary<String, Any>()
            
            paramsDic["token"] = user.token
            paramsDic["chatId"] = conversation.chatId
            paramsDic["mobile"] = conversation.receiver?.phoneNumber
            
            if (paramsJson["message"] as! String != ""){
                paramsDic["message"] = paramsJson["message"] as! String
            }
            if (paramsJson["attachment"] as! String != ""){
                paramsDic["attachment"] = paramsJson["attachment"] as! String
            }
            if (paramsJson["attachmentFileSuffix"] as! String != ""){
                paramsDic["attachmentFileSuffix"] = paramsJson["attachmentFileSuffix"] as! String
            }
            
            WebManager.sendMessage(params: paramsDic, completionBlockSuccess: { (response) -> (Void) in
                
                var tempDictionary = Dictionary<String,Any>()
                let jsonDict: Dictionary<String, Any> = response!
                
                if jsonDict["statusCode"] != nil {
                    tempDictionary["name"] = jsonDict["name"] as! String
                    tempDictionary["errorCode"] = jsonDict["errorCode"] as! Int
                    tempDictionary["message"] = jsonDict["message"] as! String
                    tempDictionary["errorCode"] = jsonDict["statusCode"] as! Int
                    let messageErr = jsonDict["message"] as! String
                    failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:messageErr]))
                }
                else {
                    
                    let messageId = jsonDict["id"] as! Int64
                    let chatId = jsonDict["chatId"] as! Int64
                    let recipientId = jsonDict["recipientId"] as! Int64
                    let senderId = jsonDict["senderId"] as! Int64
                    let messageText = jsonDict["text"] as! String
                    
                    let check : Bool = true
                    
                    var msgDate = Date()
                    if let dateStr:String = jsonDict["timeStamp"] as? String {
                        if dateStr.count > 0 {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = UTC_DATE_TIME_TZ
                            msgDate = dateFormatter.date(from: dateStr)!
                        }
                    }
                    
                    DispatchQueue.global(qos: .background).async
                        {
                            DispatchQueue.main.async
                                {
                                    let message = Message.create(context: DEFAULT_CONTEXT,
                                                                 msgTimeStamp_:msgDate,
                                                                 senderId_:senderId,
                                                                 chatId_:chatId,
                                                                 recipientId_:recipientId,
                                                                 messageId_:messageId,
                                                                 messageText_:messageText,
                                                                 isSender_: check)
                                    
                                    conversation.lastMessage = messageText

                                    CoreDataManager.coreDataManagerSharedInstance.saveContext()
                                    
                                    conversation.addToMessages(message)
                                    
                                    successBlock(message)
                            }
                    }
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
    static func composeNewMessage(mobile: String, message: String, contactId: Int64, completionBlockSuccess successBlock: @escaping ((Bool) -> (Void)), andFailureBlock failureBlock: @escaping ((Error?) -> (Void)))
    {
        if let user = User.getLoginedUser()
        {
            var paramsDic = Dictionary<String, Any>()
            
            paramsDic["token"] = user.token
            
            if (message != ""){
                paramsDic["message"] = message
            }
            if (mobile != ""){
                paramsDic["mobile"] =  Int64(mobile)
            }
            
            if (contactId != 0){
                paramsDic["contactId"] =  contactId
            }
            
            WebManager.composeMessage(params: paramsDic, completionBlockSuccess: { (response) -> (Void) in
                
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
                else {
                    
                    DispatchQueue.global(qos: .background).async
                        {
                            DispatchQueue.main.async
                                {
                                    successBlock(true)
                            }
                    }
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
            paramsDic["token"] = user.token
            paramsDic["contactId"] = params["contactId"] //Int
            paramsDic["date"] = params["date"]
            paramsDic["endDate"] = params["endDate"]
            paramsDic["reminderTime"] = params["reminderTime"] //Int
            paramsDic["message"] = params["message"]
            
            WebManager.createAppointment(params: paramsDic, completionBlockSuccess: { (response) -> (Void) in
                
                var tempDictionary = Dictionary<String,Any>()
                let jsonDict: Dictionary<String, Any> = response!
                
                if jsonDict["statusCode"] != nil {
                    
                    if (jsonDict["errorCode"] as! Int == 2000) {
                        let messageErr = jsonDict["message"] as! String
                        failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:messageErr]))
                    }
                    else {
                        tempDictionary["name"] = jsonDict["name"] as! String
                        tempDictionary["errorCode"] = jsonDict["errorCode"] as! Int
                        tempDictionary["message"] = jsonDict["message"] as! String
                        tempDictionary["errorCode"] = jsonDict["statusCode"] as! Int
                        failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:WebManager.Invalid_Token]))
                    }
                }
                else {
                    
                    if jsonDict["id"] as! Int64 > 0 {
                        
                        DispatchQueue.global(qos: .background).async
                            {
                                DispatchQueue.main.async
                                    {
                                        successBlock(true)
                                }
                        }
                    }
                    else {
                        failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:WebManager.Appointment_Error]))
                    }
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
            paramsDic["token"] = user.token
            paramsDic["chatId"] = String(conversation.chatId)
            
            WebManager.setReadReceipt(params: paramsDic, completionBlockSuccess: { (response) -> (Void) in
                
                DispatchQueue.global(qos: .background).async
                    {
                        DispatchQueue.main.async
                            {
                                let jsonDict: Dictionary<String, Any> = response!
                                
                                if (jsonDict["statusCode"] as! Int == 200 &&
                                    jsonDict["errorCode"] as! Int == 200) {
                                    
                                    successBlock(true)
                                }
                                else if (jsonDict["statusCode"] as!Int == 400 &&
                                    jsonDict["errorCode"] as! Int == 400) {
                                    
                                    let messageErr = jsonDict["message"] as! String
                                    failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:messageErr]))
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
                    
                    paramsDic["token"] = user.token
                    paramsDic["chatId"] = String(conversation.chatId)
                    
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
    static func deleteLocalConversation(conversation: Conversation, completionBlockSuccess successBlock: @escaping ((Bool) -> (Void)), andFailureBlock failureBlock: @escaping ((Error?) -> (Void)))
    {
        
        if let user = User.getLoginedUser()
        {
            var paramsDic = Dictionary<String, Any>()
            paramsDic["token"] = user.token
            paramsDic["chatID"] = String(conversation.chatId)
            
            WebManager.deleteConversation(params: paramsDic, completionBlockSuccess: { (response) -> (Void) in
                
                
                
                var tempDictionary = Dictionary<String,Any>()
                let jsonDict: Dictionary<String, Any> = response!
                
                if jsonDict["statusCode"] != nil {
                    
                    if (jsonDict["statusCode"] as! Int == 200) {
                        tempDictionary["name"] = jsonDict["name"] as! String
                        tempDictionary["errorCode"] = jsonDict["errorCode"] as! Int
                        tempDictionary["message"] = jsonDict["message"] as! String
                        tempDictionary["errorCode"] = jsonDict["statusCode"] as! Int
                        
                        DispatchQueue.global(qos: .background).async
                            {
                                DispatchQueue.main.async
                                    {
                                        User.getLoginedUser()?.removeFromConversations(conversation)
                                        
                                        do {
                                            try user.managedObjectContext?.save()
                                        }
                                        catch {
                                        }
                                        CoreDataManager.coreDataManagerSharedInstance.saveContext()
                                        successBlock(true)
                                }
                        }
                        
                    } else if (jsonDict["statusCode"] as! Int == 400) {
                        tempDictionary["name"] = jsonDict["name"] as! String
                        tempDictionary["errorCode"] = jsonDict["errorCode"] as! Int
                        tempDictionary["message"] = jsonDict["message"] as! String
                        tempDictionary["errorCode"] = jsonDict["statusCode"] as! Int
                        
                        successBlock(false)
                        
                    }
                    
                }
                else {
                    failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:WebManager.Invalid_Token]))
                }
            }, andFailureBlock: { (error:Error?) -> (Void) in
                
                if (error?.localizedDescription == "Invalid Json Format") {
                    User.getLoginedUser()?.removeFromConversations(conversation)
                    do {
                        try user.managedObjectContext?.save()
                    }
                    catch {
                    }
                    CoreDataManager.coreDataManagerSharedInstance.saveContext()
                    failureBlock(nil)
                    
                } else {
                    failureBlock(error)
                }
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
                                    
                                    failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:WebManager.Request_Completed_Error]))
                                    
                                    
                                    failureBlock(error)
                                })
                                
                        }
                }
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
    static func updateUser(params: Dictionary<String,Any>, completionBlockSuccess successBlock: @escaping ((Bool) -> (Void)), andFailureBlock failureBlock: @escaping ((Error?) -> (Void)))
    {
        if let user = User.getLoginedUser()
        {
            var paramsDic = params
            paramsDic["token"] = user.token            
            
            WebManager.putUser(params: paramsDic, completionBlockSuccess: { (response) -> (Void) in
                
                var tempDictionary = Dictionary<String,Any>()
                let jsonDict: Dictionary<String, Any> = response!
                
                if jsonDict["statusCode"] != nil {
                    
                    if jsonDict["errorCode"] as! Int == 200 {
                        
                        let user :User? = User.getLoginedUser()
                        
                        if (params.count == 1) {
                            
                            user?.updateMobile(mobile_: paramsDic["mobile"] as! String)
                            
//                            user?.update(firstName_: (user?.firstName)!,
//                                         lastName_: (user?.lastName)!,
//                                         email_: (user?.email)!,
//                                         mobile_: paramsDic["mobile"] as! String,
//                                         companyName_: (user?.companyName)!,
//                                         address_: (user?.address)!,
//                                         city_: (user?.city)!,
//                                         country_: (user?.country)!,
//                                         state_: (user?.state)!,
//                                         zipCode_: (user?.zipCode)!)
                        } else {
                            
                            user?.update(firstName_: paramsDic["firstName"] as! String,
                                         lastName_: paramsDic["lastName"] as! String,
                                         email_: paramsDic["email"] as! String,
                                         mobile_: paramsDic["mobile"] as! String,
                                         companyName_: paramsDic["companyName"] as! String,
                                         address_: paramsDic["address"] as! String,
                                         city_: paramsDic["city"] as! String,
                                         country_: paramsDic["country"] as! String,
                                         state_: paramsDic["state"] as! String,
                                         zipCode_: paramsDic["zipCode"] as! String)
                        }

//                        User.loginedUser = user
                        
                        DispatchQueue.global(qos: .background).async
                            {
                                DispatchQueue.main.async
                                    {
                                        
                                        CoreDataManager.coreDataManagerSharedInstance.saveContext()
                                        successBlock(true)
                                }
                        }
                    }
                    else if jsonDict["errorCode"] as! Int == 400 {
                        
                        failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:jsonDict["message"] as! String]))
                        
                    } else {
                        tempDictionary["name"] = jsonDict["name"] as! String
                        tempDictionary["errorCode"] = jsonDict["errorCode"] as! Int
                        tempDictionary["message"] = jsonDict["message"] as! String
                        tempDictionary["errorCode"] = jsonDict["statusCode"] as! Int
                        
                        failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:WebManager.Invalid_Token]))
                    }
                }
                else {
                    failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:WebManager.Request_Completed_Error]))
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
    static func updateContact(params: Dictionary<String,Any>, conversationObj: Conversation, completionBlockSuccess successBlock: @escaping ((Bool) -> (Void)), andFailureBlock failureBlock: @escaping ((Error?) -> (Void)))
    {
        if let user = User.getLoginedUser()
        {
            var paramsDic = params
            paramsDic["token"] = user.token
            
            WebManager.putContact(params: paramsDic, completionBlockSuccess: { (response) -> (Void) in
                
                var tempDictionary = Dictionary<String,Any>()
                let jsonDict: Dictionary<String, Any> = response!
                
                if jsonDict["statusCode"] != nil {
                    
                    if jsonDict["errorCode"] as! Int == 200 {
                        
                        DispatchQueue.global(qos: .background).async
                            {
                                DispatchQueue.main.async
                                    {
                                        if let recviver = conversationObj.receiver
                                        {
                                            if let firstName = paramsDic["firstName"] as? String {
                                                recviver.firstName = firstName
                                            }
                                            
                                            if let lastName = paramsDic["lastName"] as? String {
                                                recviver.lastName = lastName
                                            }
                                            
                                            if let email = paramsDic["email"] as? String {
                                                recviver.email = email
                                            }
                                            
                                            if let gender = paramsDic["gender"] as? String {
                                                recviver.gender = gender
                                            }
                                            
                                            if let birthDate = paramsDic["birthDate"] as? String {
                                                
                                                var birth_Date = Date(timeIntervalSinceReferenceDate: -2209014432000)
                                                
                                                        let dateFormatter = DateFormatter()
                                                        dateFormatter.dateFormat = UTC_DATE_TIME_TZ
                                                        birth_Date = dateFormatter.date(from: birthDate)!
                                                        print(birth_Date)
                                                
                                                recviver.birthDate = birth_Date
                                            }
                                                                                        
                                            if let address = paramsDic["address"] as? String {
                                                recviver.address = address
                                            }
                                            if let state = paramsDic["state"] as? String {
                                                recviver.state = state
                                            }
                                            if let zipCode = paramsDic["zipCode"] as? String {
                                                recviver.zipCode = zipCode
                                            }
                                            
                                        }
                                        
                                        CoreDataManager.coreDataManagerSharedInstance.saveContext()
                                        
                                        successBlock(true)
                                }
                        }
                    }
                    else if jsonDict["errorCode"] as! Int == 400 {
                        
                        failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:jsonDict["message"] as! String]))
                        
                    } else {
                        tempDictionary["name"] = jsonDict["name"] as! String
                        tempDictionary["errorCode"] = jsonDict["errorCode"] as! Int
                        tempDictionary["message"] = jsonDict["message"] as! String
                        tempDictionary["errorCode"] = jsonDict["statusCode"] as! Int
                        
                        failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:WebManager.Invalid_Token]))
                    }
                }
                else {
                    failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:WebManager.Request_Completed_Error]))
                }
            }, andFailureBlock: { (error) -> (Void) in
                failureBlock(error)
            })
            
        }
        else {
            failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:WebManager.User_Not_Logined]))
        }
    }
    
    static func updateContact(contact:UserContact, userDic:Dictionary<String,Any>, completionBlockSuccess successBlock: @escaping ((Bool) -> (Void)), andFailureBlock failureBlock: @escaping ((Error?) -> (Void)))
    {
        if let user = User.getLoginedUser()
        {
            var paramsDic = userDic
                
            paramsDic["token"] = user.token
            
            WebManager.putContact(params: paramsDic, completionBlockSuccess: { (response) -> (Void) in
                
                var tempDictionary = Dictionary<String,Any>()
                
                let jsonDict: Dictionary<String, Any> = response!
                
                if jsonDict["statusCode"] != nil
                {
                    if jsonDict["errorCode"] as! Int == 200
                    {
                        DispatchQueue.global(qos: .background).async
                        {
                            DispatchQueue.main.async
                            {
                                if let firstName = paramsDic["firstName"] as? String
                                {
                                    contact.firstName = firstName
                                }
                                
                                if let lastName = paramsDic["lastName"] as? String
                                {
                                    contact.lastName = lastName
                                }
                                
                                if let email = paramsDic["email"] as? String
                                {
                                    contact.email = email
                                }
                                
                                if let gender = paramsDic["gender"] as? String
                                {
                                    contact.gender = gender
                                }
                                
                                if let birthDateStr = paramsDic["birthDate"] as? String
                                {
                                    
                                    var birth_Date = Date(timeIntervalSinceReferenceDate: -2209014432000)
                                    
                                    if birthDateStr.count > 0 {
                                        let dateFormatter = DateFormatter()
                                        dateFormatter.dateFormat = UTC_DATE_TIME_TZ
                                        birth_Date = dateFormatter.date(from: birthDateStr)!
                                    }
                                    contact.birthDate = birth_Date
                                    
                                    
                                    //                                    let dateFormatter = DateFormatter()
                                    //                                    dateFormatter.dateFormat = UTC_DATE_TIME_TZ
                                    //
                                    //                                    if birthDate == "" {
                                    //                                        var birth_Date = Date(timeIntervalSinceReferenceDate:-2209014432000)
                                    //                                        birth_Date = dateFormatter.date(from: birthDate)!
                                    //                                        contact.birthDate = birth_Date
                                    //                                    } else {
                                    //                                        let dateFormatter = DateFormatter()
                                    //                                        dateFormatter.dateFormat = UTC_DATE_TIME_TZ
                                    //                                        birth_Date = dateFormatter.date(from: birthDate)!
                                    //                                        contact.birthDate = birth_Date
                                    //
                                    //                                    }
                                    //
                                    //                                    var birth_Date = Date(timeIntervalSinceReferenceDate:-2209014432000)
                                    //                                    let dateFormatter = DateFormatter()
                                    //                                    dateFormatter.dateFormat = UTC_DATE_TIME_TZ
                                    //                                    birth_Date = dateFormatter.date(from: birthDate)!
                                    //                                    contact.birthDate = birth_Date
                                }
                                    
                                    if let address = paramsDic["address"] as? String
                                    {
                                        contact.address = address
                                    }
                                    
                                    if let state = paramsDic["state"] as? String
                                    {
                                        contact.state = state
                                    }
                                    
                                    if let zipCode = paramsDic["zipCode"] as? String
                                    {
                                        contact.zipCode = zipCode
                                    }
                                    
                                    CoreDataManager.coreDataManagerSharedInstance.saveContext()
                                    
                                    successBlock(true)
                                }
                        }
                    }
                    else if jsonDict["errorCode"] as! Int == 400
                    {
                        failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:jsonDict["message"] as! String]))
                        
                    }
                    else
                    {
                        tempDictionary["name"] = jsonDict["name"] as! String
                        
                        tempDictionary["errorCode"] = jsonDict["errorCode"] as! Int
                        
                        tempDictionary["message"] = jsonDict["message"] as! String
                        
                        tempDictionary["errorCode"] = jsonDict["statusCode"] as! Int
                        
                        failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:WebManager.Invalid_Token]))
                    }
                }
                else
                {
                    failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:WebManager.Request_Completed_Error]))
                }
            }, andFailureBlock: { (error) -> (Void) in
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
    static func forgetUserPassword(params: Dictionary<String,Any>, completionBlockSuccess successBlock: @escaping ((Bool) -> (Void)), andFailureBlock failureBlock: @escaping ((Error?) -> (Void)))
    {
        //        if let user = User.getLoginedUser()
        //        {
        var paramsDic = Dictionary<String, Any>()
        //paramsDic["token"] = user.token
        paramsDic["mobile"] = params["mobile"]
        
        WebManager.forgetPassword(params: paramsDic, completionBlockSuccess: { (response) -> (Void) in
            
            var tempDictionary = Dictionary<String,Any>()
            let jsonDict: Dictionary<String, Any> = response!
            
            if jsonDict["statusCode"] != nil {
                
                if jsonDict["errorCode"] as! Int == 2000 {
                    
                    failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:WebManager.User_Not_Found]))
                    
                } else {
                    tempDictionary["name"] = jsonDict["name"] as! String
                    tempDictionary["errorCode"] = jsonDict["errorCode"] as! Int
                    tempDictionary["message"] = jsonDict["message"] as! String
                    tempDictionary["errorCode"] = jsonDict["statusCode"] as! Int
                    
                    let messageErr = tempDictionary["message"] as! String

                    failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:messageErr]))
                }
            }
            else {
                
                DispatchQueue.global(qos: .background).async
                    {
                        DispatchQueue.main.async
                            {
                                successBlock(true)
                        }
                }
            }
        }, andFailureBlock: { (error) -> (Void) in
            failureBlock(error)
        })
        
        //        }
        //        else {
        //            failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:WebManager.User_Not_Logined]))
        //        }
    }
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    static func verifyNumber(params: Dictionary<String,Any>, completionBlockSuccess successBlock: @escaping ((Bool) -> (Void)), andFailureBlock failureBlock: @escaping ((Error?) -> (Void)))
    {
        if let user = User.getLoginedUser()
        {
            var paramsDic = params
            paramsDic["token"] = user.token
            
            WebManager.verifyMobileNumber(params: paramsDic, completionBlockSuccess: { (response) -> (Void) in
                
                var tempDictionary = Dictionary<String,Any>()
                let jsonDict: Dictionary<String, Any> = response!
                
                if jsonDict["statusCode"] != nil {
                    
                    if (jsonDict["statusCode"] as! Int == 200) {

                        DispatchQueue.global(qos: .background).async
                            {
                                DispatchQueue.main.async
                                    {
                                        successBlock(true)
                                }
                        }
                    } else if (jsonDict["statusCode"] as! Int == 400) {
                        successBlock(false)
                        
                    } else {
                        
                        tempDictionary["name"] = jsonDict["name"] as! String
                        tempDictionary["errorCode"] = jsonDict["errorCode"] as! Int
                        tempDictionary["message"] = jsonDict["message"] as! String
                        tempDictionary["errorCode"] = jsonDict["statusCode"] as! Int

                    failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:WebManager.Invalid_Token]))
                    }
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
    static func getThemeForWhiteLabelId(params: Dictionary<String,Any>, completionBlockSuccess successBlock: @escaping ((Bool) -> (Void)), andFailureBlock failureBlock: @escaping ((Error?) -> (Void)))
    {
        if let user = User.getLoginedUser()
        {
            var paramsDic = Dictionary<String, Any>()
            paramsDic["token"] = user.token
            paramsDic["whiteLabelId"] =  String(user.whiteLableConfigurationId)
            
            WebManager.getThemes(params: paramsDic, completionBlockSuccess: { (response) -> (Void) in
                
                let jsonDict: Dictionary<String, Any> = response!
                
                if jsonDict["statusCode"] != nil {
                    
                    if (jsonDict["errorCode"] as! Int == 2000) {
                        let messageErr = jsonDict["message"] as! String
                        failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:messageErr]))
                    }
                    else {
                        let messageErr = jsonDict["message"] as! String
                        failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:messageErr]))
                    }
                }
                else {
                    
                    DispatchQueue.global(qos: .background).async
                        {
                            DispatchQueue.main.async
                                {
                                    //---------- ---------- ---------- ---------- ---------- ----------//
                                    let colorString = jsonDict["primaryColor"] as! String
//                                    colorString = colorString.replacingOccurrences(of: "#", with: "")

                                    AppThemeHex = colorString
                                    AppThemeColor = UIColor(hexString: colorString)

                                    //---------- ---------- ---------- ---------- ---------- ----------//
                                    successBlock(true)
                            }
                    }
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
    @discardableResult
    // MARK: -
    // MARK: CONTACT CONVERSATION ASSIGNMENT
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
                    var isSenderFound = false
                   
//                    print(" ===== ===== ===== Conversation ID ===== ===== ===== ", conv.chatId)
                    
                    for contact in contracts
                    {
                        
                        if conv.senderId == contact.contactId
                        {
//                            print("SenderID ===== ===== ===== )", conv.senderId)

                            conv.sender = contact
                            isSenderFound = true
                        }
                        
                        if conv.contactId == contact.contactId
                        {
//                            print("ReceiverID ===== ===== ===== (", conv.contactId)

                            conv.receiver = contact
                            isSenderFound = true
                        }
                        
                        
//                        if conv.receiver == nil {
//                            NSLog("========== ========== ReceiverID ========== ========== ")
//                        }
//                        
//                        if conv.sender == nil {
//                            NSLog("========== ========== SenderID ========== ========== ")
//                        }
                    }
                    
                    if isSenderFound == false
                    {
                        NSLog("===== ----- >>>>> FAIL TO ATTACH CONTACT WITH CONVERSATION <<<<< ----- =====")
                    }
                }
            }
            
        } catch _ as NSError {
//                        print("Could not fetch \(error)”)
        }
        
        return true
    }
}
