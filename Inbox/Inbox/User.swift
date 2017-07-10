//
//  User.swift
//  Inbox
//
//  Created by Amir Akram on 10/07/2017.
//  Copyright © 2017 Amir Akram. All rights reserved.
//

import UIKit

class User: NSObject {
   
    var serial:String
    var uuid:String
    var isRemember:Bool
    
    private var loginedUser:User? = nil

    init(serial_:String, uuid_:String, isRemember_:Bool) {
        
        self.serial = serial_
        self.uuid = uuid_
        self.isRemember = isRemember_
        
        super.init()
    }
    
    static func getLoginedUser()->User{
        
        return loginedUser
    }
    
    
    static func loginwith(serial_:String, uuid_:String, isRemember_:Bool){
        self.serial = serial_
        self.uuid = uuid_
        self.isRemember = isRemember_
    }

    
    func loginWithUser(params: serial_:String, uuid_:String, isRemember_:Bool, completionBlockSuccess successBlock: @escaping ((AnyObject?) -> (Void)), andFailureBlock failureBlock: @escaping ((Error?) -> (Void))) {
    
    
    
    }

}
