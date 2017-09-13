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
    
    static func create(context: NSManagedObjectContext, serial:String,uuid:String,isRemember:Bool) -> User
    {
        var targettedUser:User? = nil
        
        if let user = User.getUserFromID(serial_: serial)
        {
            targettedUser = user
            
        } else {
            
            targettedUser = User(context: context)
        }
        
        targettedUser?.serial = serial
        targettedUser?.uuid = uuid
        targettedUser?.isRemember = isRemember
        
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
    
    static func getUserFromID(serial_: String) -> User? {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let predicate = NSPredicate(format: "serial == %@", serial_)
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

extension User {
    
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
                            
                            
                            
                            let user :User? = User.create(context: DEFAULT_CONTEXT ,serial:serial, uuid:uuid, isRemember:isRemember)
                            
                            User.loginedUser = user
                            
                            self.getLatestConversations(completionBlockSuccess: { (conversations: Array<Conversation>?) -> (Void) in
                                
                                //user.conversations?.addingObjects(from:conversations!)
                                successBlock(user)
                                
                            }, andFailureBlock: { (error: Error?) -> (Void) in
                                //
                            })
                    }
            }
            
        }) { (error: Error?) -> (Void) in
            failureBlock(error)
            
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
            
            WebManager.requestConversations(params:paramsDic, conversationParser: ConversationParser(),completionBlockSuccess:{(conversations:Array<Conversation>?) -> (Void) in
                
                DispatchQueue.global(qos: .background).async
                    {
                        DispatchQueue.main.async
                            {
                                //user.conversations?.addingObjects(from:conversations!)
                                
                                for conversation in conversations!
                                {
                                    conversation.user = user
                                }
                                
                                do {
                                    
                                    try user.managedObjectContext?.save()
                                }
                                catch {
                                    
                                }
                                
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
            paramsDic["mobile"] = conversation.mobile
            paramsDic["shortCode"] = conversation.mobile
            
            WebManager.getMessages(params:paramsDic,messageParser:MessagesParser(conversation),completionBlockSuccess:{(messages:Array<Message>?) -> (Void) in
                
                DispatchQueue.global(qos: .background).async
                    {
                        DispatchQueue.main.async
                            {
                                for message in messages!
                                {
                                    message.conversation = conversation
                                }
                                
                                do {
                                    
                                    try user.managedObjectContext?.save()
                                }
                                catch {
                                    
                                }
                                
                                // conversation.messages?.addingObjects(from: messages!)
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
            paramsDic["mobile"] = conversation.mobileNumber
            
            WebManager.optOutMessage(params: paramsDic, completionBlockSuccess: { (response) -> (Void) in
                
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
    static func sendUserMessage(conversation: Conversation, message: String, completionBlockSuccess successBlock: @escaping ((_ messageNew: Message) -> (Void)), andFailureBlock failureBlock: @escaping ((Error?) -> (Void)))
    {
        if let user = User.getLoginedUser()
        {
            var paramsDic = Dictionary<String, Any>()
            
            paramsDic["serial"] = user.serial
            paramsDic["uuid"] = user.uuid
            paramsDic["mobile"] = conversation.mobileNumber
            paramsDic["message"] = message
            
            if (conversation.shortcodeDisplay == "TollFree") && !(conversation.tollFree == "") {
                paramsDic["shortCode"] = conversation.tollFree
            } else {
                paramsDic["shortCode"] = conversation.shortcodeDisplay
            }
            
            WebManager.sendMessage(params: paramsDic, completionBlockSuccess: { (response) -> (Void) in
                
                if let status = response?["result"] as? String
                {
                    
                    if (status == "OK") {
                        
                        var msgDate = Date()
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MM/dd/YYYY hh:mm:ss a"
                        let dateString = dateFormatter.string(from: msgDate)
                        msgDate = dateFormatter.date(from: dateString)!
                        
                        DispatchQueue.global(qos: .background).async
                            {
                                DispatchQueue.main.async
                                    {
                                        let message = Message.create(context: DEFAULT_CONTEXT, date_: msgDate, message_: message, messageId_:0, mobile_: conversation.mobile!, shortCode_: conversation.shortCode!, isSender_: true, isRead_: false, updatedOn_: 0, createdOn_: 0)
                                        
                                        conversation.messages?.adding(message)
                                        successBlock(message)
                                }
                        }
                        
                    } else {
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
                    
                    if (status == "OK") {
                        
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
            paramsDic["mobile"] = conversation.mobile
            paramsDic["shortCode"] = conversation.shortcodeDisplay

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
            paramsDic["mobile"] = conversation.mobile
            paramsDic["shortCode"] = conversation.shortCode
            
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
}
//************************************************************************************************//
//------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------//
//************************************************************************************************//

