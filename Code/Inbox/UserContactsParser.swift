//
//  ConversationParser.swift
//  Inbox
//
//  Created by Amir Akram on 09/08/2017.
//  Copyright © 2017 Amir Akram. All rights reserved.
//

import Foundation
//************************************************************************************************//
//------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------//
//************************************************************************************************//
class UserContactsParser: NSObject
{
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    func parseUserContacts(json:Dictionary<String,Any>) -> Array<UserContact>
    {
        var contactsArr = Array<UserContact>()
        
        var tempDictionary = Dictionary<String,Any>()
        
        if json["statusCode"] != nil {
            tempDictionary["name"] = json["name"] as! String
            tempDictionary["errorCode"] = json["errorCode"] as! Int64
            tempDictionary["message"] = json["message"] as! String
            tempDictionary["statusCode"] = json["statusCode"] as! Int64
        } else {
            
            let contactsArray = json["contacts"] as! Array<Dictionary<String,Any>>
            
            for dic in contactsArray
            {
                if dic.count > 0
                {
                    let fName = checkStringForNull(value: (dic["firstName"] as AnyObject)).trimmingCharacters(in: .whitespaces).capitalized
                    let lName = checkStringForNull(value: (dic["lastName"] as AnyObject)).trimmingCharacters(in: .whitespaces).capitalized
                    let phoneNo = checkStringForNull(value: (dic["phoneNumber"] as AnyObject))
                    let gender = checkStringForNull(value: (dic["gender"] as AnyObject))
                    let email = checkStringForNull(value: (dic["email"] as AnyObject))
                    let contactId = dic["id"] as! Int64
                    let locationDict = dic["locationDetails"] as! Dictionary<String,Any>
                    let country = checkStringForNull(value: (locationDict["country"] as AnyObject))
                    let zipCode = checkStringForNull(value: (locationDict["zipCode"] as AnyObject))
                    let address = checkStringForNull(value: (locationDict["address"] as AnyObject))
                    let city = checkStringForNull(value: (locationDict["city"] as AnyObject))
                    let state = checkStringForNull(value: (locationDict["state"] as AnyObject))
                    //let birth_Date = checkStringForNull(value: (locationDict["birthDate"] as AnyObject))
                    
                    var contact: UserContact? = UserContact.getContactFromID(conID: contactId)
                    
                    var birth_Date = Date(timeIntervalSinceReferenceDate: -2209014432000) // Feb 2, 1997, 10:26 AM
                    
                    if let dateStr:String = dic["birthDate"] as? String {
                        if dateStr.count > 0 {

                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = UTC_DATE_TIME_TZ
                            birth_Date = dateFormatter.date(from: dateStr)!
                            //print(birth_Date)
                        }
                    } else {
//                       birth_Date = nil
                    }
                    
//                    if (fName + lName).trimmingCharacters(in: .whitespaces).count < 1
//                    {
//                        if phoneNo.trimmingCharacters(in: .whitespaces).count > 1
//                        {
//                            fName = phoneNo
//                        }
//                        else if email.trimmingCharacters(in: .whitespaces).count > 1
//                        {
//                             fName = email
//                        }
//                    }
                    
                    
                    if contact == nil {
                        
                        contact = UserContact.create(context: DEFAULT_CONTEXT,
                                                     firstName_: fName,
                                                     lastName_: lName,
                                                     phoneNumber_: phoneNo,
                                                     gender_: gender,
                                                     country_: country,
                                                     zipCode_: zipCode,
                                                     address_: address,
                                                     city_: city,
                                                     state_: state,
                                                     birthDate_: birth_Date,
                                                     email_: email,
                                                     contactId_: contactId)
                        
                        contactsArr.append(contact!)
                        
                        let currentUser = User.loginedUser
                        
                        currentUser?.addToUserContacts(contact!)

                    }
                    else
                    {
                        contact?.update(firstName_: fName,
                                        lastName_: lName,
                                        phoneNumber_: phoneNo,
                                        gender_: gender,
                                        country_: country,
                                        zipCode_: zipCode,
                                        address_: address,
                                        city_: city,
                                        state_: state,
                                        birthDate_: birth_Date,
                                        email_: email,
                                        contactId_: contactId)
                        
                        contactsArr.append(contact!)
                    }
                }
            }
            
            /*
            //----- Check Login User Contact Start-----//
            let currentUser = User.loginedUser
            var currentContact: UserContact? = UserContact.getContactFromID(conID: (currentUser?.userId)!)
            
            if currentContact == nil {
                
                currentContact = UserContact.create(context: DEFAULT_CONTEXT,
                                                    firstName_: (currentUser?.firstName)!,
                                                    lastName_: (currentUser?.lastName)!,
                                                    phoneNumber_: (currentUser?.formattedUsername)!,
                                                    gender_: "",
                                                    country_: (currentUser?.country)!,
                                                    zipCode_: (currentUser?.zipCode)!,
                                                    address_: (currentUser?.address)!,
                                                    city_: (currentUser?.city)!,
                                                    state_: (currentUser?.state)!,
                                                    birthDate_: Date(),
                                                    email_: (currentUser?.email)!,
                                                    contactId_: (currentUser?.userId)!)
                contactsArr.append(currentContact!)
            }
            else
            {
                currentContact?.update(firstName_: (currentUser?.firstName)!,
                                       lastName_: (currentUser?.lastName)!,
                                       phoneNumber_: (currentUser?.formattedUsername)!,
                                       gender_: (currentContact?.gender)!,
                                       country_: (currentUser?.country)!,
                                       zipCode_: (currentUser?.zipCode)!,
                                       address_: (currentUser?.address)!,
                                       city_: (currentUser?.city)!,
                                       state_: (currentUser?.state)!,
                                       birthDate_:  (currentContact?.birthDate)!,
                                       email_: (currentUser?.email)!,
                                       contactId_: (currentUser?.userId)!)
                
                contactsArr.append(currentContact!)
            }
            //----- Check Login User Contact End -----// */
        }
        
        return contactsArr
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
