import UIKit

class Contact: NSObject
{
    var contacName = ""

    static func dummyContact() -> Contact
    {
        let contact = Contact()

        contact.contacName = "Amir Akram"
        
        return contact
    }
}
