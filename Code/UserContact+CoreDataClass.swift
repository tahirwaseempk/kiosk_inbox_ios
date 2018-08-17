//
//  UserContact+CoreDataClass.swift
//  Inbox
//
//  Created by Amir Akram on 12/08/2018.
//  Copyright © 2018 Amir Akram. All rights reserved.
//
//

import Foundation
import CoreData

//@objc(UserContact)
public class UserContact: NSManagedObject
{

  static func getContactFromID(conID: Int64) -> UserContact? {
        
        //        let filteredMessages = messages?.filter { ($0 as! Message).messageId == messID }
        //
        //        if (filteredMessages?.count)! > 0 {
        //            return filteredMessages?.first as? Message
        //        }
        //
        return nil;
    }
}

extension UserContact {
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    static func create(context: NSManagedObjectContext, firstName_: String, lastName_: String, phoneNumber_: String, gender_: String, country_: String, zipCode_: String, address_: String, city_: String, state_: String, birthDate_: Date, email_: String, contactId_: Int64) -> UserContact {
        
        let contact = UserContact(context: context)
        
        contact.firstName = firstName_
        contact.lastName = lastName_
        contact.phoneNumber = phoneNumber_
        contact.gender = gender_
        contact.country = country_
        contact.zipCode = zipCode_
        contact.address = address_
        contact.city = city_
        contact.state = state_
        contact.birthDate = birthDate_
        contact.email = email_
        contact.contactId = contactId_
        
        return contact
    }
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    func update(firstName_: String,lastName_: String, phoneNumber_: String, gender_: String, country_: String, zipCode_: String, address_: String, city_: String, state_: String, birthDate_: Date, email_: String, contactId_: Int64) {
        
        self.firstName = firstName_
        self.lastName = lastName_
        self.phoneNumber = phoneNumber_
        self.gender = gender_
        self.country = country_
        self.zipCode = zipCode_
        self.address = address_
        self.city = city_
        self.state = state_
        self.birthDate = birthDate_
        self.email = email_
        self.contactId = contactId_
        
    }
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
}
//************************************************************************************************//
//------------------------------------------------------------------------------------------------//
//************************************************************************************************//
