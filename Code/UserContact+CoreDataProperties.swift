//
//  UserContact+CoreDataProperties.swift
//  Inbox
//
//  Created by Amir Akram on 12/08/2018.
//  Copyright © 2018 Amir Akram. All rights reserved.
//
//

import Foundation
import CoreData


extension UserContact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserContact> {
        return NSFetchRequest<UserContact>(entityName: "UserContact")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var gender: String?
    @NSManaged public var country: String?
    @NSManaged public var zipCode: String?
    @NSManaged public var address: String?
    @NSManaged public var city: String?
    @NSManaged public var state: String?
    @NSManaged public var birthDate: Date?
    @NSManaged public var email: String?
    
    @NSManaged public var contactId: Int64
}



