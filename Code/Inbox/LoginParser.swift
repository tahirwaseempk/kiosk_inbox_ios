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
        // let mainDictionary = json["statusCode"] as! Dictionary<String,Any>
        //let keyExists = json["statusCode"] != nil
        
        if json["statusCode"] != nil {
            returnDictionary["name"] = json["name"] as! String
            returnDictionary["errorCode"] = json["errorCode"] as! String
            returnDictionary["message"] = json["message"] as! String
            returnDictionary["statusCode"] = json["statusCode"] as! String
        } else {
            
            returnDictionary["token"] = json["token"] as! String
            let userDict = json["user"] as! Dictionary<String,Any>
            returnDictionary["userId"] = userDict["id"] as! Int64
            returnDictionary["username"] = userDict["username"] as! String
            returnDictionary["formattedUsername"] = userDict["formattedUsername"] as! String
            returnDictionary["email"] = userDict["email"] as! String
            returnDictionary["phone"] = userDict["phone"] as! String
            returnDictionary["mobile"] = userDict["mobile"] as! String
            returnDictionary["firstName"] = userDict["firstName"] as! String
            returnDictionary["lastName"] = userDict["lastName"] as! String
            returnDictionary["companyName"] = userDict["companyName"] as! String
            let locationDict = userDict["locationDetails"] as! Dictionary<String,Any>
            returnDictionary["address"] = locationDict["address"] as! String
            returnDictionary["city"] = locationDict["city"] as! String
            returnDictionary["country"] = locationDict["country"] as! String
            returnDictionary["state"] = locationDict["state"] as! String
            returnDictionary["zipCode"] = locationDict["zipCode"] as! String
            returnDictionary["whiteLableConfigurationId"] = userDict["whiteLableConfigurationId"] as! Int64
            returnDictionary["userGroupId"] = userDict["userGroupId"] as! Int64
            returnDictionary["timezone"] = userDict["timezone"] as! Int64
            returnDictionary["license"] = userDict["license"] as! String
        }
        
        //        if (json["err"] as? String) != nil
        //        {
        //            return json
        //        }
        //
        return returnDictionary
    }
}
//************************************************************************************************//
//------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------//
//************************************************************************************************//
