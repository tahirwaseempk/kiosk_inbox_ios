import UIKit
import Foundation

//************************************************************************************************//
//------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------//
//************************************************************************************************//

//**********************************************************//
//----------------------------------------------------------//
//----------------------------------------------------------//
//**********************************************************//
let URL_TEXTING_LINE  = "https://services.textingline.com"
//let URL_TEXTING_LINE  = "https://api.textingline.com"

let URL_SMS_FACTORY   = "https://services.textingline.com"
let URL_FANCONNECT    = "https://services.textingline.com"
let URL_PHOTO_TEXTING = "https://services.textingline.com"
//----------------------------------------------------------//
let LOGIN = "/api/v1/auth/login"
let GET_CONVERSATIONS = "/api/v1/chats/"
let GET_CONVERSATIONS_LIMIT = "?limit="
let GET_CONVERSATIONS_EMOJI = "&isEmojiAliases="
let GET_MESSAGES = "/api/v1/messages/"
let DELETE_CONVERSATION = "/api/v1/chats/"
let SEND_MESSAGE = "/api/v1/messages/"
let COMPOSE_MESSAGE = "/api/v1/messages/startNewChatMsg"
let CREATE_APPOINTMENT = "/api/v1/appointments/"
let GET_CONTACTS = "/api/v1/contacts/?onlyWithChat="
let READ_MESSAGES = "/api/v1/chats/clearUnreadMsgs/"
let PUT_USER = "/api/v1/user/"
let GET_USER = "/api/v1/auth/user"
let FORGET_PASSWORD = "/api/v1/auth/resetPassword"
let BYPASS_MESSAGE = "/api/v1/messages/byPass"

let THEME_COLOR = "/api/v1/themes/whiteLabel/"
//----------------------------------------------------------//
let PUT_TOKEN_URL = "/api/v1/pushtoken"
let DELETE_TOKEN_URL = "/api/v1/pushtoken/?"
//************************************************************************************************//
//------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------//
//************************************************************************************************//
class WebManager: NSObject
{
    static let Check_Internet_Question  = "Please Check your Internet Connection"
    static let Invalid_Json_Format      = "Invalid Json Format"
    static let Server_Not_Responding    = "Server is not responding"
    static let User_Not_Logined         = "User is not logined"
    static let Invalid_Token            = "Unexpected token in JSON"
    static let Appointment_Error        = "Failed to create Appointment"
    static let Json_Parameters_Error    = "Parameters fail"
    static let Wrong_User_Passwprd      = "Please provide correct Username/Password."
    static let User_Not_Found           = "User Not Found"
    static let Request_Completed_Error  = "Request Not Completed Sucessfully"
    override init()
    {
        super.init()
    }
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //------------------------------------------------------------------------------------------------//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    static func requestLogin(params: Dictionary<String,Any>,loginParser:LoginParser, completionBlockSuccess successBlock: @escaping ((Dictionary<String,Any>?) -> (Void)), andFailureBlock failureBlock: @escaping ((Error?) -> (Void)))
    {
        
        let dictionary1 = Bundle.main.infoDictionary!
        let version     = dictionary1["CFBundleShortVersionString"] as! String
        let build       = dictionary1["CFBundleVersion"] as! String
        let systemVersion = UIDevice.current.systemVersion

        
        var paramsDic = Dictionary<String, Any>()
        paramsDic["username"] = params["username"] as! String
        paramsDic["password"] = params["password"] as! String
        
        var clientMetadata = Dictionary<String, Any>()
        clientMetadata["type"] = "NATIVE"
        clientMetadata["os"] = "iOS"
        clientMetadata["osVersion"] = systemVersion
        clientMetadata["appVersion"] = version + " (" + build + ")"
        

        if let ipAddress = getWiFiAddress() {
            clientMetadata["loginIp"] = ipAddress
        } else {
            print("No WiFi address")
        }

        var pushTokenDetails = Dictionary<String, Any>()
        
        if let token = UserDefaults.standard.string(forKey: "fireBaseToken")
        {
            pushTokenDetails["token"] = token
        } else {
            pushTokenDetails["token"] = ""
        }
        
        pushTokenDetails["tokenProvider"] = "Firebase"

        paramsDic["clientMetadata"] = clientMetadata
        paramsDic["pushTokenDetails"] = pushTokenDetails

        
        var finalUrl = ""
        
        switch environment {
            
        case .texting_Line:
            finalUrl = URL_TEXTING_LINE + LOGIN
        case .sms_Factory:
            finalUrl = URL_SMS_FACTORY + LOGIN
        case .fan_Connect:
            finalUrl = URL_FANCONNECT + LOGIN
        case .photo_Texting:
            finalUrl = URL_PHOTO_TEXTING + LOGIN
        }
        
        print("\n ===== >>>>> login URL = \(finalUrl) \n")
        
        callNewWebService(urlStr: finalUrl, parameters: paramsDic, httpMethod: "POST", httpHeaderKey: "", httpHeaderValue: "", completionBlock: {(error, response) -> (Void) in
            
            if (error == nil)
            {
                let dictionary = loginParser.parseUser(json:response as! Dictionary<String, Any>)
                
                if (response?["errorCode"] as? String) != nil
                {
                    failureBlock(error)
                } else {
                    successBlock(dictionary)
                }
            }
            else
            {
                failureBlock(error)
            }
        })
    }
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //------------------------------------------------------------------------------------------------//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    static func registerAPNS(params: Dictionary<String,Any>, completionBlockSuccess successBlock: @escaping ((Dictionary<String,Any>?) -> (Void)), andFailureBlock failureBlock: @escaping ((Error?) -> (Void)))
    {
        
        let userToken:String = params["token"] as! String

        var paramsDic = Dictionary<String, Any>()
        
        if let token = UserDefaults.standard.string(forKey: "fireBaseToken")
        {
            paramsDic["token"] = token
        } else {
            paramsDic["token"] = ""
        }
        
        paramsDic["tokenProvider"] = "Firebase"
        
        var finalUrl = ""
        
        switch environment {
        case .texting_Line:
            finalUrl = URL_TEXTING_LINE + PUT_TOKEN_URL
        case .sms_Factory:
            finalUrl = URL_SMS_FACTORY + PUT_TOKEN_URL
        case .fan_Connect:
            finalUrl = URL_FANCONNECT + PUT_TOKEN_URL
        case .photo_Texting:
            finalUrl = URL_PHOTO_TEXTING + PUT_TOKEN_URL
        }
        
        print("\n ===== >>>>> Register APNS URL  = \(finalUrl) \n")
        
        callNewWebService(urlStr: finalUrl, parameters: paramsDic, httpMethod: "PUT", httpHeaderKey: "authorization", httpHeaderValue: userToken, completionBlock: {(error, response) -> (Void) in
            
            if (error == nil)
            {
                successBlock(response as? Dictionary<String, Any>)
                
            } else {
                
                failureBlock(error)
            }
            
        })
    }
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //------------------------------------------------------------------------------------------------//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    static func deleteAPNS(params: Dictionary<String,Any>, completionBlockSuccess successBlock: @escaping ((Dictionary<String,Any>?) -> (Void)), andFailureBlock failureBlock: @escaping ((Error?) -> (Void)))
    {
        
        let token:String = params["token"] as! String
        
        var pushToken:String = ""
        
        if let tokenFCM = UserDefaults.standard.string(forKey: "fireBaseToken")
        {
            pushToken = tokenFCM
        }
        
        let tokenProvider:String = "Firebase"

        
        var finalUrl = ""
        
        switch environment {

        case .texting_Line:
            finalUrl = URL_TEXTING_LINE + DELETE_TOKEN_URL + "pushToken=" + pushToken + "&pushTokenProvider=" + tokenProvider
        case .sms_Factory:
            finalUrl = URL_SMS_FACTORY + DELETE_TOKEN_URL + "pushToken=" + pushToken + "&pushTokenProvider=" + tokenProvider
        case .fan_Connect:
            finalUrl = URL_FANCONNECT + DELETE_TOKEN_URL + "pushToken=" + pushToken + "&pushTokenProvider=" + tokenProvider
        case .photo_Texting:
            finalUrl = URL_PHOTO_TEXTING + DELETE_TOKEN_URL + "pushToken=" + pushToken + "&pushTokenProvider=" + tokenProvider
        }
        
        print("\n ===== >>>>> Delete APNS URL = \(finalUrl) \n")
        
        callNewWebService(urlStr: finalUrl, parameters: Dictionary<String, Any>(), httpMethod: "DELETE", httpHeaderKey: "authorization", httpHeaderValue: token, completionBlock: {(error, response) -> (Void) in
            
            if (error == nil)
            {
                successBlock(response as? Dictionary<String, Any>)
                
            } else {
                
                failureBlock(error)
            }
            
        })
    }
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //------------------------------------------------------------------------------------------------//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    static func requestConversations(params: Dictionary<String,Any>,conversationParser:ConversationParser, completionBlockSuccess successBlock: @escaping ((Array<Conversation>?) -> (Void)), andFailureBlock failureBlock: @escaping ((Error?) -> (Void)))
    {
        
        let token:String = params["token"] as! String
        
        var finalUrl = ""
        
        switch environment {
            
        case .texting_Line:
            finalUrl = URL_TEXTING_LINE + GET_CONVERSATIONS + GET_CONVERSATIONS_LIMIT + LIMIT + GET_CONVERSATIONS_EMOJI + EMOJI
        case .sms_Factory:
            finalUrl = URL_SMS_FACTORY + GET_CONVERSATIONS + GET_CONVERSATIONS_LIMIT + LIMIT + GET_CONVERSATIONS_EMOJI + EMOJI
        case .fan_Connect:
            finalUrl = URL_FANCONNECT + GET_CONVERSATIONS + GET_CONVERSATIONS_LIMIT + LIMIT + GET_CONVERSATIONS_EMOJI + EMOJI
        case .photo_Texting:
            finalUrl = URL_PHOTO_TEXTING + GET_CONVERSATIONS + GET_CONVERSATIONS_LIMIT + LIMIT + GET_CONVERSATIONS_EMOJI + EMOJI
        }
        
        print("\n ===== >>>>> Conversations URL = \(finalUrl) \n")
        
        callNewWebService(urlStr: finalUrl, parameters: Dictionary<String, Any>(), httpMethod: "GET", httpHeaderKey: "authorization", httpHeaderValue: token, completionBlock: {(error, response) -> (Void) in
            
            if (error == nil)
            {
                DispatchQueue.global(qos: .background).async
                    {
                        DispatchQueue.main.async
                            {
                                let responseDict = response as! Dictionary<String,Any>
                                if responseDict["statusCode"] != nil {
                                    let errorMessage = responseDict["message"] as! String
                                    failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:errorMessage]))
                                } else {
                                    successBlock(conversationParser.parseConversations(json:response as! Dictionary<String, Any>))
                                }
                        }
                }
            }
            else
            {
                failureBlock(error)
            }
        })
    }
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //------------------------------------------------------------------------------------------------//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    static func optOutMessage(params: Dictionary<String,Any>, completionBlockSuccess successBlock: @escaping ((Dictionary<String, Any>?)  -> (Void)), andFailureBlock: @escaping ((Error?) -> (Void)))
    {
        
        let uuid:String = params["uuid"] as! String
        let serial:String = params["serial"] as! String
        let mobile:String = params["mobile"] as! String
        
        var finalUrl = ""
        
//        switch environment {
//
//        case .texting_Line:
//            finalUrl = URL_TEXTING_LINE + OPTOUT_URL_SERIAL + serial + OPTOUT_URL_BEFORE_MOBILE + mobile + OPTOUT_URL_UUID + uuid
//        case .sms_Factory:
//            finalUrl = URL_SMS_FACTORY + OPTOUT_URL_SERIAL + serial + OPTOUT_URL_BEFORE_MOBILE + mobile + OPTOUT_URL_UUID + uuid
//        case .fan_Connect:
//            finalUrl = URL_FANCONNECT + OPTOUT_URL_SERIAL + serial + OPTOUT_URL_BEFORE_MOBILE + mobile + OPTOUT_URL_UUID + uuid
//        case .photo_Texting:
//            finalUrl = URL_PHOTO_TEXTING + OPTOUT_URL_SERIAL + serial + OPTOUT_URL_BEFORE_MOBILE + mobile + OPTOUT_URL_UUID + uuid
//        }
        
        print("\n ===== >>>>> OPTOUT URL = \(finalUrl) \n")
        
        callNewWebService(urlStr: finalUrl, parameters: Dictionary<String, Any>(), httpMethod: "POST", httpHeaderKey: "", httpHeaderValue: "", completionBlock: {(error, response) -> (Void) in
            
            if (error == nil)
            {
                successBlock(response as? Dictionary<String, Any>)
            }
            else
            {
                andFailureBlock(error)
            }
        })
    }
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //------------------------------------------------------------------------------------------------//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    static func deleteConversation(params: Dictionary<String,Any>, completionBlockSuccess successBlock: @escaping ((Dictionary<String, Any>?)  -> (Void)), andFailureBlock: @escaping ((Error?) -> (Void)))
    {
        
        let token:String = params["token"] as! String
        let chatId:String = params["chatID"] as! String
        
        var finalUrl = ""
        
        switch environment {
        case .texting_Line:
            finalUrl =  URL_TEXTING_LINE + DELETE_CONVERSATION + chatId
        case .sms_Factory:
            finalUrl =  URL_SMS_FACTORY + DELETE_CONVERSATION + chatId
        case .fan_Connect:
            finalUrl =  URL_FANCONNECT + DELETE_CONVERSATION + chatId
        case .photo_Texting:
            finalUrl =  URL_PHOTO_TEXTING + DELETE_CONVERSATION + chatId
        }
        
        print("\n ===== >>>>> Delete Conversation URL = \(finalUrl) \n")
        
        callNewWebService(urlStr: finalUrl, parameters: Dictionary<String, Any>(), httpMethod: "DELETE", httpHeaderKey: "authorization", httpHeaderValue: token, completionBlock: {(error, response) -> (Void) in
            
            if (error == nil)
            {
                successBlock(response as? Dictionary<String, Any>)
            }
            else
            {
                andFailureBlock(error)
            }
        })
    }
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //------------------------------------------------------------------------------------------------//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    static func setReadReceipt(params: Dictionary<String,Any>, completionBlockSuccess successBlock: @escaping ((Dictionary<String, Any>?)  -> (Void)), andFailureBlock: @escaping ((Error?) -> (Void)))
    {
        let token:String = params["token"] as! String
        let chatId:String = params["chatId"] as! String
        
        var finalUrl = ""
        
        switch environment {
            
        case .texting_Line:
            finalUrl = URL_TEXTING_LINE + READ_MESSAGES + chatId
        case .sms_Factory:
            finalUrl = URL_SMS_FACTORY + READ_MESSAGES + chatId
        case .fan_Connect:
            finalUrl = URL_FANCONNECT + READ_MESSAGES + chatId
        case .photo_Texting:
            finalUrl = URL_PHOTO_TEXTING + READ_MESSAGES + chatId
        }
        
        print("\n ===== >>>>> Read Receipt URL = \(finalUrl) \n")
        
        callNewWebService(urlStr: finalUrl, parameters: Dictionary<String, Any>(), httpMethod: "PATCH", httpHeaderKey: "authorization", httpHeaderValue: token, completionBlock: {(error, response) -> (Void) in
            
            if (error == nil)
            {
                successBlock(response as? Dictionary<String, Any>)
            }
            else
            {
                andFailureBlock(error)
            }
        })
    }
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //------------------------------------------------------------------------------------------------//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    static func getMessages(params: Dictionary<String,Any>,messageParser:MessagesParser,completionBlockSuccess successBlock: @escaping ((Array<Message>?) -> (Void)), andFailureBlock failureBlock: @escaping ((Error?) -> (Void)))
    {
        
        let chatID:String = params["chatID"] as! String
        let token:String = params["token"] as! String

        var finalUrl = ""
        
        switch environment {
            
        case .texting_Line:
            finalUrl = URL_TEXTING_LINE + GET_MESSAGES + chatID
        case .sms_Factory:
            finalUrl = URL_SMS_FACTORY + GET_MESSAGES + chatID
        case .fan_Connect:
            finalUrl = URL_FANCONNECT + GET_MESSAGES + chatID
        case .photo_Texting:
            finalUrl = URL_PHOTO_TEXTING + GET_MESSAGES + chatID
        }
        
        print("\n ===== >>>>> Get Message URL = \(finalUrl) \n")
        
        callNewWebService(urlStr: finalUrl, parameters: Dictionary<String, Any>(), httpMethod: "GET", httpHeaderKey: "authorization", httpHeaderValue: token, completionBlock: {(error, response) -> (Void) in
            
            if (error == nil)
            {
                DispatchQueue.global(qos: .background).async
                    {
                        DispatchQueue.main.async
                            {
                                let responseDict = response as! Dictionary<String,Any>
                                if responseDict["statusCode"] != nil {
                                    let errorMessage = responseDict["message"] as! String
                                    failureBlock(NSError(domain:"com.inbox.amir",code:400,userInfo:[NSLocalizedDescriptionKey:errorMessage]))
                                } else {
                                    successBlock(messageParser.parseMessages(json:response as! Dictionary<String, Any>))
                                }
                        }
                }
                
            }
            else
            {
                failureBlock(error)
            }
        })
    }
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //------------------------------------------------------------------------------------------------//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    static func sendMessage(params: Dictionary<String,Any>, completionBlockSuccess successBlock: @escaping ((Dictionary<String, Any>?) -> (Void)), andFailureBlock failureBlock: @escaping ((Error?) -> (Void)))
    {
        let token:String = params["token"] as! String
        
        var paramsDictionary = Dictionary<String, Any>()
        
        paramsDictionary["text"] = params["message"] as! String
        paramsDictionary["chatId"] = params["chatId"] as! Int64
        
        var finalUrl = ""
        
        switch environment {
            
        case .texting_Line:
            finalUrl = URL_TEXTING_LINE + SEND_MESSAGE
        case .sms_Factory:
            finalUrl = URL_SMS_FACTORY + SEND_MESSAGE
        case .fan_Connect:
            finalUrl = URL_FANCONNECT + SEND_MESSAGE
        case .photo_Texting:
            finalUrl = URL_PHOTO_TEXTING + SEND_MESSAGE
        }
        
        print("\n ===== >>>>> Send Message URL = \(finalUrl) \n")
        
        callNewWebService(urlStr: finalUrl, parameters: paramsDictionary, httpMethod: "POST", httpHeaderKey: "authorization", httpHeaderValue: token, completionBlock: {(error, response) -> (Void) in
            
            if (error == nil)
            {
                successBlock(response as? Dictionary)
            }
            else
            {
                failureBlock(error)
            }
        })
    }
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //------------------------------------------------------------------------------------------------//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    static func composeMessage(params: Dictionary<String,Any>, completionBlockSuccess successBlock: @escaping ((Dictionary<String, Any>?) -> (Void)), andFailureBlock failureBlock: @escaping ((Error?) -> (Void)))
    {
        let token:String = params["token"] as! String
        
        var paramsDictionary = Dictionary<String, Any>()
        
        
        if (params["message"] as! String != ""){
            paramsDictionary["text"] = params["message"] as! String
        }
        if (params["contactId"] != nil) {
            paramsDictionary["contactId"] = params["contactId"] as! Int64
        }
        if (params["mobile"] != nil) {
            paramsDictionary["mobile"] = params["mobile"] as! Int64
        }
        
        var finalUrl = ""
        
        switch environment {
        case .texting_Line:
            finalUrl = URL_TEXTING_LINE + COMPOSE_MESSAGE
        case .sms_Factory:
            finalUrl = URL_SMS_FACTORY + COMPOSE_MESSAGE
        case .fan_Connect:
            finalUrl = URL_FANCONNECT + COMPOSE_MESSAGE
        case .photo_Texting:
            finalUrl = URL_PHOTO_TEXTING + COMPOSE_MESSAGE
        }
        
        print("\n ===== >>>>> Compose Message URL = \(finalUrl) \n")
        
        callNewWebService(urlStr: finalUrl, parameters: paramsDictionary, httpMethod: "POST", httpHeaderKey: "authorization", httpHeaderValue: token, completionBlock: {(error, response) -> (Void) in
            
            if (error == nil)
            {
                successBlock(response as? Dictionary)
            }
            else
            {
                failureBlock(error)
            }
        })
    }
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //------------------------------------------------------------------------------------------------//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    static func createAppointment(params: Dictionary<String,Any>, completionBlockSuccess successBlock: @escaping ((Dictionary<String, Any>?) -> (Void)), andFailureBlock failureBlock: @escaping ((Error?) -> (Void)))
    {
        
        let token:String = params["token"] as! String
        
        var paramsDictionary = Dictionary<String, Any>()
        paramsDictionary["contactId"] = params["contactId"] as! Int64
        paramsDictionary["date"] = params["date"] as! String
        paramsDictionary["endDate"] = params["endDate"] as! String
        paramsDictionary["reminderTime"] = params["reminderTime"] as! Int64
        paramsDictionary["message"] = params["message"] as! String
        
        var finalUrl = ""
        
        switch environment {
        case .texting_Line:
            finalUrl = URL_TEXTING_LINE + CREATE_APPOINTMENT
        case .sms_Factory:
            finalUrl = URL_SMS_FACTORY + CREATE_APPOINTMENT
        case .fan_Connect:
            finalUrl = URL_FANCONNECT + CREATE_APPOINTMENT
        case .photo_Texting:
            finalUrl = URL_PHOTO_TEXTING + CREATE_APPOINTMENT
        }
        
        print("\n ===== >>>>> Create Appoinment URL = \(finalUrl) \n")
        
        callNewWebService(urlStr: finalUrl, parameters: paramsDictionary, httpMethod: "POST", httpHeaderKey: "authorization", httpHeaderValue: token, completionBlock: {(error, response) -> (Void) in
            
            if (error == nil)
            {
                successBlock(response as? Dictionary)
            }
            else
            {
                failureBlock(error)
            }
        })
    }
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //------------------------------------------------------------------------------------------------//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    static func getAllContacs(params: Dictionary<String,Any>,contactParser:UserContactsParser,completionBlockSuccess successBlock: @escaping ((Array<UserContact>?) -> (Void)), andFailureBlock failureBlock: @escaping ((Error?) -> (Void)))
    {
        let token:String = params["token"] as! String
        
        var finalUrl = ""
        
        switch environment {
            
        case .texting_Line:
            finalUrl = URL_TEXTING_LINE + GET_CONTACTS + CONTACTSWITHCHAT
        case .sms_Factory:
            finalUrl = URL_SMS_FACTORY + GET_CONTACTS + CONTACTSWITHCHAT
        case .fan_Connect:
            finalUrl = URL_FANCONNECT + GET_CONTACTS + CONTACTSWITHCHAT
        case .photo_Texting:
            finalUrl = URL_PHOTO_TEXTING + GET_CONTACTS + CONTACTSWITHCHAT
        }
        
        print("\n ===== >>>>> Get Contacts URL = \(finalUrl) \n")
        
        callNewWebService(urlStr: finalUrl, parameters: Dictionary<String, Any>(), httpMethod: "GET", httpHeaderKey: "authorization", httpHeaderValue: token, completionBlock: {(error, response) -> (Void) in
            
            if (error == nil)
            {
                DispatchQueue.global(qos: .background).async
                    {
                        DispatchQueue.main.async
                            {
                                successBlock(contactParser.parseUserContacts(json:response as! Dictionary<String, Any>))
                        }
                }
                
            }
            else
            {
                failureBlock(error)
            }
        })
    }
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //------------------------------------------------------------------------------------------------//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    static func putUser(params: Dictionary<String,Any>, completionBlockSuccess successBlock: @escaping ((Dictionary<String, Any>?) -> (Void)), andFailureBlock failureBlock: @escaping ((Error?) -> (Void)))
    {
        
        let token:String = params["token"] as! String
        
        var paramsDictionary = Dictionary<String, Any>()
        
        if (params["email"] != nil) {
            paramsDictionary["email"] = params["email"] as! String
        }
        if (params["mobile"] != nil) {
            paramsDictionary["mobile"] = params["mobile"] as! String
        }
        if (params["firstName"] != nil) {
            paramsDictionary["firstName"] = params["firstName"] as! String
        }
        if (params["lastName"] != nil) {
            paramsDictionary["lastName"] = params["lastName"] as! String
        }
        if (params["companyName"] != nil) {
            paramsDictionary["companyName"] = params["companyName"] as! String
        }
        if (params["address"] != nil) {
            paramsDictionary["address"] = params["address"] as! String
        }
        if (params["city"] != nil) {
            paramsDictionary["city"] = params["city"] as! String
        }
        if (params["country"] != nil) {
            paramsDictionary["country"] = params["country"] as! String
        }
        if (params["state"] != nil) {
            paramsDictionary["state"] = params["state"] as! String
        }
        if (params["zipCode"] != nil) {
            paramsDictionary["zipCode"] = params["zipCode"] as! String
        }
        
        var finalUrl = ""
        
        switch environment {
        case .texting_Line:
            finalUrl = URL_TEXTING_LINE + PUT_USER
        case .sms_Factory:
            finalUrl = URL_SMS_FACTORY + PUT_USER
        case .fan_Connect:
            finalUrl = URL_FANCONNECT + PUT_USER
        case .photo_Texting:
            finalUrl = URL_PHOTO_TEXTING + PUT_USER
        }
        
        print("\n ===== >>>>> Put User URL = \(finalUrl) \n")
        
        callNewWebService(urlStr: finalUrl, parameters: paramsDictionary, httpMethod: "PUT", httpHeaderKey: "authorization", httpHeaderValue: token, completionBlock: {(error, response) -> (Void) in
            
            if (error == nil)
            {
                successBlock(response as? Dictionary)
            }
            else
            {
                failureBlock(error)
            }
        })
    }
    
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //------------------------------------------------------------------------------------------------//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    static func forgetPassword(params: Dictionary<String,Any>, completionBlockSuccess successBlock: @escaping ((Dictionary<String, Any>?) -> (Void)), andFailureBlock failureBlock: @escaping ((Error?) -> (Void)))
    {
        //let token:String = params["token"] as! String
       
        var paramsDictionary = Dictionary<String, Any>()
        paramsDictionary["username"] = params["mobile"] as! String
        
        var finalUrl = ""
        
        switch environment {
            
        case .texting_Line:
            finalUrl = URL_TEXTING_LINE + FORGET_PASSWORD
        case .sms_Factory:
            finalUrl = URL_SMS_FACTORY + FORGET_PASSWORD
        case .fan_Connect:
            finalUrl = URL_FANCONNECT + FORGET_PASSWORD
        case .photo_Texting:
            finalUrl = URL_PHOTO_TEXTING + FORGET_PASSWORD
        }
        
        print("\n ===== >>>>> Forget Password URL = \(finalUrl) \n")
        
        callNewWebService(urlStr: finalUrl, parameters: paramsDictionary, httpMethod: "POST", httpHeaderKey: "authorization", httpHeaderValue: "", completionBlock: {(error, response) -> (Void) in
            
            if (error == nil)
            {
                successBlock(response as? Dictionary)
            }
            else
            {
                failureBlock(error)
            }
        })
    }
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //------------------------------------------------------------------------------------------------//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    static func verifyMobileNumber(params: Dictionary<String,Any>, completionBlockSuccess successBlock: @escaping ((Dictionary<String, Any>?) -> (Void)), andFailureBlock failureBlock: @escaping ((Error?) -> (Void)))
    {
        let token:String = params["token"] as! String
       
        var paramsDictionary = Dictionary<String, Any>()
        paramsDictionary["text"] = params["message"] as! String
        paramsDictionary["mobile"] = params["mobile"] as! String

        var finalUrl = ""
        
        switch environment {
            
        case .texting_Line:
            finalUrl = URL_TEXTING_LINE + BYPASS_MESSAGE
        case .sms_Factory:
            finalUrl = URL_SMS_FACTORY + BYPASS_MESSAGE
        case .fan_Connect:
            finalUrl = URL_FANCONNECT + BYPASS_MESSAGE
        case .photo_Texting:
            finalUrl = URL_PHOTO_TEXTING + BYPASS_MESSAGE
        }
        
        print("\n ===== >>>>> By Pass Message URL = \(finalUrl) \n")
        
        callNewWebService(urlStr: finalUrl, parameters: paramsDictionary, httpMethod: "POST", httpHeaderKey: "authorization", httpHeaderValue: token, completionBlock: {(error, response) -> (Void) in
            
            if (error == nil)
            {
                successBlock(response as? Dictionary)
            }
            else
            {
                failureBlock(error)
            }
        })
    }
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //------------------------------------------------------------------------------------------------//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //------------------------------------------------------------------------------------------------//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    static func getThemes(params: Dictionary<String,Any>, completionBlockSuccess successBlock: @escaping ((Dictionary<String, Any>?) -> (Void)), andFailureBlock failureBlock: @escaping ((Error?) -> (Void)))
    {
        
        let whiteLabelId:String = params["whiteLabelId"] as! String
        let token:String = params["token"] as! String

        var finalUrl = ""
        
        switch environment {
        case .texting_Line:
            finalUrl = URL_TEXTING_LINE + THEME_COLOR + whiteLabelId
        case .sms_Factory:
            finalUrl = URL_SMS_FACTORY + THEME_COLOR + whiteLabelId
        case .fan_Connect:
            finalUrl = URL_FANCONNECT + THEME_COLOR + whiteLabelId
        case .photo_Texting:
            finalUrl = URL_PHOTO_TEXTING + THEME_COLOR + whiteLabelId
        }
        
        print("\n ===== >>>>> Get Theme URL = \(finalUrl) \n")
        
        callNewWebService(urlStr: finalUrl, parameters: Dictionary<String, Any>(), httpMethod: "GET", httpHeaderKey: "authorization", httpHeaderValue: token, completionBlock: {(error, response) -> (Void) in
            
            if (error == nil)
            {
                successBlock(response as? Dictionary)
            }
            else
            {
                failureBlock(error)
            }
        })
    }
    internal static func callNewWebService(urlStr: String, parameters: Dictionary<String,Any>, httpMethod: String, httpHeaderKey: String, httpHeaderValue: String, completionBlock completion: @escaping ((_ error : Error?, _ response : NSDictionary?) -> (Void)))
    {
        
        //create the url with NSURL
        let url = NSURL(string: urlStr)
        //create the session object
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = httpMethod //set http method as POST
        
        if (httpMethod == "POST" || httpMethod == "PUT") {
            
            if (parameters.keys.count > 0) {
                var jsonData: Data? = nil
                jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                if jsonData != nil {
                    let theJSONText = NSString(data: jsonData!,encoding: String.Encoding.utf8.rawValue)
                    print("JSON string = \(theJSONText!)")
                }
                request.httpBody = jsonData
            }
        }
        else {
            if (parameters.keys.count > 0) {
                let postString = (parameters.compactMap({ (key, value) -> String in
                    return "\(key)=\(value)"
                }) as Array).joined(separator: "&")
                print("\(postString) \n")
                
                request.httpBody = postString.data(using: String.Encoding.utf8)
            }
        }
        
        
        
        if httpHeaderValue.isEmpty == false {
            request.setValue(httpHeaderValue, forHTTPHeaderField: httpHeaderKey)
        }
        
        //HTTP Headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else
            {
                return
            }
            
            guard let data = data else
            {
                return
            }
            
            if request.url?.lastPathComponent == "byPass" {
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        var statusDict = Dictionary<String, Any>()
                        statusDict["statusCode"] = httpResponse.statusCode
                        statusDict["errorCode"] = httpResponse.statusCode
                        statusDict["name"] = "RequestCompletedSucessfully"
                        statusDict["message"] = "Request Completed Sucessfully"
                        completion(nil,statusDict as NSDictionary)
                        return
                        
                    } else if httpResponse.statusCode == 400 {
                        var statusDict = Dictionary<String, Any>()
                        statusDict["statusCode"] = httpResponse.statusCode
                        statusDict["errorCode"] = httpResponse.statusCode
                        statusDict["name"] = "BadRequestError"
                        statusDict["message"] = "Request Not Completed Sucessfully"
                        completion(nil,statusDict as NSDictionary)
                        return
                    }
                    else {
                        completion(NSError(domain: "com.chat.sms", code: 400, userInfo: [NSLocalizedDescriptionKey : WebManager.Json_Parameters_Error]),nil)
                        return
                    }
                }
                
            }
            
            if (httpMethod == "DELETE" || httpMethod == "PATCH" || httpMethod == "PUT"){
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        var statusDict = Dictionary<String, Any>()
                        statusDict["statusCode"] = httpResponse.statusCode
                        statusDict["errorCode"] = httpResponse.statusCode
                        statusDict["name"] = "RequestCompletedSucessfully"
                        statusDict["message"] = "Request Completed Sucessfully"
                        completion(nil,statusDict as NSDictionary)
                        return
                        
                    } else if httpResponse.statusCode == 400 {
                        var statusDict = Dictionary<String, Any>()
                        statusDict["statusCode"] = httpResponse.statusCode
                        statusDict["errorCode"] = httpResponse.statusCode
                        statusDict["name"] = "BadRequestError"
                        statusDict["message"] = "Request Not Completed Sucessfully"
                        completion(nil,statusDict as NSDictionary)
                        return
                    }
                    else {
                        completion(NSError(domain: "com.chat.sms", code: 400, userInfo: [NSLocalizedDescriptionKey : WebManager.Json_Parameters_Error]),nil)
                        return
                    }
                    /*
                     if let statusCode = httpResponse.allHeaderFields["Access-Control-Allow-Origin"] as? String {
                     }
                     if let statusCode = httpResponse.allHeaderFields["Content-Length"] as? String {
                     }
                     if let statusCode = httpResponse.allHeaderFields["Date"] as? String {
                     }
                     if let statusCode = httpResponse.allHeaderFields["Etag"] as? String {
                     }
                     if let statusCode = httpResponse.allHeaderFields["x-powered-by"] as? String {
                     }*/
                }
            }
            
            let responseStrInISOLatin = String(data: data, encoding: String.Encoding.isoLatin1)
            
            guard let modifiedDataInUTF8Format = responseStrInISOLatin?.data(using: String.Encoding.utf8)
                else
            {
                completion(NSError(domain: "com.chat.sms", code: 400, userInfo: [NSLocalizedDescriptionKey : WebManager.Server_Not_Responding]),nil)
                print("could not convert data to UTF-8 format")
                return
            }
            
            do
            {
                if let responseJSONDict = try JSONSerialization.jsonObject(with: modifiedDataInUTF8Format) as? [String: Any]
                {
                    completion(nil,responseJSONDict as NSDictionary)
                }
                else
                {
                    completion(NSError(domain: "com.chat.sms", code: 400, userInfo: [NSLocalizedDescriptionKey : WebManager.Server_Not_Responding]),nil)
                }
            }
            catch
            {
                print(error.localizedDescription)
                
                let code = (error as NSError).code
                
                if(code == 3840)
                {
                    
                    completion(NSError(domain: "com.chat.sms", code: 3840, userInfo: [NSLocalizedDescriptionKey : WebManager.Invalid_Json_Format]),nil)
                }
                else
                {
                    completion(error,nil);
                }
            }
        })
        
        task.resume()
    }
}
//************************************************************************************************//
//------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------//
//************************************************************************************************//
