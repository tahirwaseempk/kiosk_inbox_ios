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
        let user = User(context: context)
        user.serial = serial
        user.uuid = uuid
        user.isRemember = isRemember
        return user
    }
    
    static func getLoginedUser()-> User?
    {
        return loginedUser
    }
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //------------------------------------------------------------------------------------------------//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
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
                            let user = User.create(context: DEFAULT_CONTEXT ,serial:serial,uuid:uuid,isRemember:isRemember)
                            
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
    //------------------------------------------------------------------------------------------------//
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
    //------------------------------------------------------------------------------------------------//
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
            
            WebManager.getMessages(params:paramsDic,messageParser:MessagesParser(),completionBlockSuccess:{(messages:Array<Message>?) -> (Void) in
                
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
    //------------------------------------------------------------------------------------------------//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    static func sendUserMessage(conversation: Conversation, message: String, completionBlockSuccess successBlock: @escaping ((_ messageNew: Message) -> (Void)), andFailureBlock failureBlock: @escaping ((Error?) -> (Void)))
    {
        if let user = User.getLoginedUser()
        {
            var paramsDic = Dictionary<String, Any>()
            
            paramsDic["serial"] = user.serial
            paramsDic["uuid"] = user.uuid
            paramsDic["mobile"] = conversation.mobile
            paramsDic["shortCode"] = conversation.shortCode
            paramsDic["message"] = message
            
            WebManager.sendMessage(params: paramsDic, completionBlockSuccess: { (response) -> (Void) in
                
                if let isSucceeded = response?["result"] as? String
                {
                    
                    if (isSucceeded == "OK") {
                        
                        let date = Date()
                        let formatter = DateFormatter()
                        formatter.dateFormat = "dd/MM/yyyy hh:mm:ss a"
                        let dateString = formatter.string(from: date)
                        
                        DispatchQueue.global(qos: .background).async
                            {
                                DispatchQueue.main.async
                                    {
                                        let message = Message.create(context: DEFAULT_CONTEXT, date_: dateString, message_: message, messageId_:0, mobile_: conversation.mobile!, shortCode_: conversation.shortCode!, isSender_: true, isRead_: false, updatedOn_: 0, createdOn_: 0)
                                        
                                        conversation.messages?.adding(message)
                                        successBlock(message)
                                }
                        }
                        
                    } else {
                        failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:isSucceeded]))
                    }
                    
                }
                else if let isSucceeded = response?["err"] as? String
                {
                    
                    failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:isSucceeded]))
                    
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
    //------------------------------------------------------------------------------------------------//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
}

