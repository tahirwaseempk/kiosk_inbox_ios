//
//  MessagesParser.swift
//  Inbox
//
//  Created by Amir Akram on 21/06/2017.
//  Copyright © 2017 Amir Akram. All rights reserved.
//

import Foundation
//************************************************************************************************//
//------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------//
//************************************************************************************************//
class LoginParser: NSObject {
    func parseUser(json:Dictionary<String,Any>) -> Dictionary<String,Any>
    {
        var returnDictionary = Dictionary<String,Any>()
        
        if json["statusCode"] != nil {
            returnDictionary["name"] = json["name"] as! String
            returnDictionary["errorCode"] = json["errorCode"] as! Int64
            returnDictionary["message"] = json["message"] as! String
            returnDictionary["statusCode"] = json["statusCode"] as! Int64
            
        } else {
            returnDictionary["token"] = json["token"] as! String
            let userDict = json["user"] as! Dictionary<String,Any>
            
            returnDictionary["userId"] = checkIntForNull(value: (userDict["id"] as AnyObject))
            returnDictionary["username"] = checkStringForNull(value: (userDict["username"] as AnyObject))
            returnDictionary["formattedUsername"] = checkStringForNull(value: (userDict["formattedUsername"] as AnyObject))
            returnDictionary["email"] = checkStringForNull(value: (userDict["email"] as AnyObject))
            returnDictionary["phone"] = checkStringForNull(value: (userDict["phone"] as AnyObject))
            returnDictionary["mobile"] = checkStringForNull(value: (userDict["mobile"] as AnyObject))
            returnDictionary["firstName"] = checkStringForNull(value: (userDict["firstName"] as AnyObject))
            returnDictionary["lastName"] = checkStringForNull(value: (userDict["lastName"] as AnyObject))
            returnDictionary["companyName"] = checkStringForNull(value: (userDict["companyName"] as AnyObject))
            returnDictionary["whiteLableConfigurationId"] = checkIntForNull(value: (userDict["whiteLableConfigurationId"] as AnyObject))
            returnDictionary["userGroupId"] = checkIntForNull(value: (userDict["userGroupId"] as AnyObject))
            returnDictionary["timezone"] = checkIntForNull(value: (userDict["timezone"] as AnyObject))
            returnDictionary["license"] = checkStringForNull(value: (userDict["license"] as AnyObject))
            
            let locationDict = userDict["locationDetails"] as! Dictionary<String,Any>
            returnDictionary["address"] = checkStringForNull(value: (locationDict["address"] as AnyObject))
            returnDictionary["city"] = checkStringForNull(value: (locationDict["city"] as AnyObject))
            returnDictionary["country"] = checkStringForNull(value: (locationDict["country"] as AnyObject))
            returnDictionary["state"] = checkStringForNull(value: (locationDict["state"] as AnyObject))
            returnDictionary["zipCode"] = checkStringForNull(value: (locationDict["zipCode"] as AnyObject))
            
        }
        
        return returnDictionary
    }
}
//************************************************************************************************//
//------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------//
//************************************************************************************************//
