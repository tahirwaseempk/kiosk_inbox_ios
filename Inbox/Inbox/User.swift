//
//  User.swift
//  Inbox
//
//  Created by Amir Akram on 10/07/2017.
//  Copyright © 2017 Amir Akram. All rights reserved.
//

import UIKit

class User: NSObject
{
    var serial:String
    
    var uuid:String
    
    var isRemember:Bool
    
    var conversations:Array<ConversationDataModel>
    
    private static var loginedUser:User? = nil

    internal init(serial:String,uuid:String,isRemember:Bool)
    {
        self.serial = serial
        
        self.uuid = uuid
        
        self.isRemember = isRemember
        
        self.conversations = Array<ConversationDataModel>()
        
        super.init()
    }
    
    static func getLoginedUser()->User?
    {
        return loginedUser
    }
    
    static func loginWithUser(serial:String, uuid:String, isRemember:Bool, completionBlockSuccess successBlock: @escaping ((User?) -> (Void)), andFailureBlock failureBlock: @escaping ((Error?) -> (Void)))
    {
        var paramsDic = Dictionary<String, Any>()
        
        paramsDic["serial"] = serial
        
        paramsDic["uuid"] = uuid

        WebManager.requestLogin(params: paramsDic,messageParser: MessagesParser(), completionBlockSuccess: { (conversations:Array<ConversationDataModel>?) -> (Void) in

            DispatchQueue.global(qos: .background).async
            {
                DispatchQueue.main.async
                {
                    let user = User(serial:serial,uuid:uuid,isRemember:isRemember)
                    
                    user.conversations += conversations!
                    
                    User.loginedUser = user
                    
                    successBlock(user)
                }
            }
            
        }){(error:Error?) -> (Void) in
            
            failureBlock(error)
        }
    }

    static func getLatestConversations(completionBlockSuccess successBlock: @escaping ((Array<ConversationDataModel>?) -> (Void)), andFailureBlock failureBlock: @escaping ((Error?) -> (Void)))
    {
        if let user = User.getLoginedUser()
        {
            var paramsDic = Dictionary<String, Any>()
            
            paramsDic["serial"] = user.serial
            
            paramsDic["uuid"] = user.uuid
            
            WebManager.requestLogin(params:paramsDic,messageParser:MessagesParser(),completionBlockSuccess:{(conversations:Array<ConversationDataModel>?) -> (Void) in
                
                DispatchQueue.global(qos: .background).async
                {
                    DispatchQueue.main.async
                    {
                        user.conversations.removeAll()

                        user.conversations += conversations!
                        
                        successBlock(user.conversations)
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
}
