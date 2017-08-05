//
//  MessagesDataModel.swift
//  Inbox
//
//  Created by Amir Akram on 21/06/2017.
//  Copyright © 2017 Amir Akram. All rights reserved.
//

import UIKit

class MessagesDataModel: NSObject {
    
    var date:String
    var message:String
    var id:Int
    var mobile:String
    let shortCode:String
    var isSender: Bool
    
    init(date_:String,message_:String, id_:Int, mobile_:String, shortCode_:String, isSender_:Bool) {
        
        self.date = date_
        self.message = message_
        self.id = id_
        self.mobile = mobile_
        self.shortCode = shortCode_
        
        self.isSender = isSender_
        
        super.init()
        
    }
    
}
