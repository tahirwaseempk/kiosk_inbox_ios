import UIKit
import Foundation

//************************************************************************************************//
//------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------//
//************************************************************************************************//

let URL_SMS_FACTORY = "https://mcpn.us/limeApi"
let URL_TEXTING_LINE = "https://app.textingline.com/limeApi"

let LOGIN_URL = "?ev=kioskInbox&serial="
let LOGIN_URL_END = "&uuid="

let APNS_URL = "?ev=kioskAddToken&serial="
let APNS_URL_UDID = "&uuid="
let APNS_URL_TYPE = "&type="
let APNS_URL_TOKEN = "&token="

let DELETE_APNS_URL = "?ev=kioskDeleteToken&serial="
let DELETE_APNS_URL_UDID = "&uuid="
let DELETE_APNS_URL_TYPE = "&type="
let DELETE_APNS_URL_TOKEN = "&token="

let OPTOUT_URL_SERIAL = "?ev=kioskInboxOptOut&serial="
let OPTOUT_URL_BEFORE_MOBILE = "&mobile="
let OPTOUT_URL_UUID = "&uuid="

let CHAT_URL = "?ev=kioskChatMessages&uuid="
let CHAT_URL_BEFORE_SERIAL = "&serial="
let CHAT_URL_BEFORE_MOBILE = "&mobile="
let CHAT_URL_BEFORE_SHORTCODE = "&shortcode="

let SEND_URL = "?ev=kioskSendMessage&uuid="
let SEND_URL_BEFORE_SERIAL = "&serial="
let SEND_URL_BEFORE_SHORTCODE = "&shortcode="
let SEND_URL_BEFORE_MOBILE = "&mobile="
let SEND_URL_BEFORE_MESSAGE = "&message="
let SEND_URL_BEFORE_IMAGETYPE = "&attachmentFileSuffix="
let SEND_URL_BEFORE_IMAGE = "&attachment="

let CONVERSATION_URL = "?ev=kioskInboxWithDetails&uuid="
let CONVERSATION_URL_END = "&serial="

let READ_URL_BEFORE_SERIAL = "?ev=kioskInboxSetReadByMobile&serial="
let READ_URL_BEFORE_UUID = "&uuid="
let READ_URL_BEFORE_ISREAD = "&isRead="
let READ_URL_BEFORE_MOBILE = "&mobile="
let READ_URL_BEFORE_SHORTCODE_END = "&shortcode="

let DELETE_URL = "?ev=kioskInboxDeleteForNumber&uuid="
let DELETE_URL_BEFORE_SERIAL = "&serial="
let DELETE_URL_BEFORE_MOBILE = "&mobile="
let DELETE_URL_BEFORE_SHORTCODE = "&shortcode="

let CREATE_APPOINMENT_URL = "?ev=kioskInboxCreateAppointment&json="

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
        
        let serial:String = params["serial"] as! String
        let uuid:String = params["uuid"] as! String
        
        var finalUrl = ""
        
        switch environment {
            
        case .texting_Line:
            finalUrl = URL_TEXTING_LINE + LOGIN_URL + serial + LOGIN_URL_END + uuid
            
        case .sms_Factory:
            finalUrl = URL_SMS_FACTORY + LOGIN_URL + serial + LOGIN_URL_END + uuid
        }
        
        print("===== >>>>> login URL = \(finalUrl)")
        
        PostDataWithUrl(urlString:finalUrl, withParameterDictionary:Dictionary(),completionBlock: {(error, response) -> (Void) in
            
            if (error == nil)
            {
                let dictionary = loginParser.parseUser(json:response as! Dictionary<String, Any>)
                
                if (response?["err"] as? String) != nil
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
        
        let serial:String = params["serial"] as! String
        let uuid:String   = params["uuid"] as! String
        let type:String   = params["type"] as! String
        
        let keyExists = params["token"] != nil
        var tokenKey:String
        if keyExists {
            tokenKey = params["token"] as! String
        } else {
            tokenKey = ""
        }
        
        var finalUrl = ""
        
        switch environment {
            
        case .texting_Line:
            finalUrl = URL_TEXTING_LINE + APNS_URL + serial + APNS_URL_UDID + uuid + APNS_URL_TYPE + type + APNS_URL_TOKEN + tokenKey
            
        case .sms_Factory:
            finalUrl = URL_SMS_FACTORY + APNS_URL + serial + APNS_URL_UDID + uuid + APNS_URL_TYPE + type + APNS_URL_TOKEN + tokenKey
        }
        
        print("===== >>>>> Register APNS URL  = \(finalUrl)")
        
        PostDataWithUrl(urlString:finalUrl, withParameterDictionary:Dictionary(),completionBlock: {(error, response) -> (Void) in
            
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
        
        let serial:String = params["serial"] as! String
        let uuid:String   = params["uuid"] as! String
        let type:String   = params["type"] as! String
        
        let keyExists = params["token"] != nil
        var tokenKey:String
        if keyExists {
            tokenKey = params["token"] as! String
        } else {
            tokenKey = ""
        }
        
        var finalUrl = ""
        
        switch environment {
            
        case .texting_Line:
            finalUrl = URL_TEXTING_LINE + DELETE_APNS_URL + serial + DELETE_APNS_URL_UDID + uuid + DELETE_APNS_URL_TYPE + type + DELETE_APNS_URL_TOKEN + tokenKey
            
        case .sms_Factory:
            finalUrl = URL_SMS_FACTORY + DELETE_APNS_URL + serial + DELETE_APNS_URL_UDID + uuid + DELETE_APNS_URL_TYPE + type + DELETE_APNS_URL_TOKEN + tokenKey
        }
        
        print("===== >>>>> Delete APNS URL = \(finalUrl)")
        
        PostDataWithUrl(urlString:finalUrl, withParameterDictionary:Dictionary(),completionBlock: {(error, response) -> (Void) in
            
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
        
        let serial:String = params["serial"] as! String
        let uuid:String = params["uuid"] as! String
        
        var finalUrl = ""
        
        switch environment {
            
        case .texting_Line:
            finalUrl = URL_TEXTING_LINE + CONVERSATION_URL + uuid + CONVERSATION_URL_END + serial
            
        case .sms_Factory:
            finalUrl = URL_SMS_FACTORY + CONVERSATION_URL + uuid + CONVERSATION_URL_END + serial
        }
        
        print("===== >>>>> Conversations URL = \(finalUrl)")
        
        PostDataWithUrl(urlString:finalUrl, withParameterDictionary:Dictionary(),completionBlock: {(error, response) -> (Void) in
            
            if (error == nil)
            {
                DispatchQueue.global(qos: .background).async
                    {
                        DispatchQueue.main.async
                            {
                                successBlock(conversationParser.parseConversations(json:response as! Dictionary<String, Any>))
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
        //let mobile_ = removeSpecialCharsFromString(mobile)
        
        var finalUrl = ""
        
        switch environment {
            
        case .texting_Line:
            finalUrl = URL_TEXTING_LINE + OPTOUT_URL_SERIAL + serial + OPTOUT_URL_BEFORE_MOBILE + mobile + OPTOUT_URL_UUID + uuid
            
            
        case .sms_Factory:
            finalUrl = URL_SMS_FACTORY + OPTOUT_URL_SERIAL + serial + OPTOUT_URL_BEFORE_MOBILE + mobile + OPTOUT_URL_UUID + uuid
        }
        
        print("===== >>>>> OPTOUT URL = \(finalUrl)")
        
        PostDataWithUrl(urlString:finalUrl, withParameterDictionary:Dictionary(),completionBlock: {(error, response) -> (Void) in
            
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
        
        let uuid:String = params["uuid"] as! String
        let serial:String = params["serial"] as! String
        let mobile:String = params["mobile"] as! String
        let shortCode:String = params["shortCode"] as! String
        
        var finalUrl = ""
        
        switch environment {
            
        case .texting_Line:
            finalUrl =  URL_TEXTING_LINE + DELETE_URL + uuid + DELETE_URL_BEFORE_SERIAL + serial + DELETE_URL_BEFORE_MOBILE + mobile + DELETE_URL_BEFORE_SHORTCODE + shortCode
            
        case .sms_Factory:
            finalUrl =  URL_SMS_FACTORY + DELETE_URL + uuid + DELETE_URL_BEFORE_SERIAL + serial + DELETE_URL_BEFORE_MOBILE + mobile + DELETE_URL_BEFORE_SHORTCODE + shortCode
        }
        
        print("===== >>>>> Delete Conversation URL = \(finalUrl)")
        
        PostDataWithUrl(urlString:finalUrl, withParameterDictionary:Dictionary(),completionBlock: {(error, response) -> (Void) in
            
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
        let uuid:String = params["uuid"] as! String
        let serial:String = params["serial"] as! String
        let mobile:String = params["mobile"] as! String
        let shortCode:String = params["shortCode"] as! String
        let mobile_ = removeSpecialCharsFromString(mobile)
        
        var finalUrl = ""
        
        switch environment {
            
        case .texting_Line:
            finalUrl = URL_TEXTING_LINE + READ_URL_BEFORE_SERIAL + serial + READ_URL_BEFORE_UUID + uuid + READ_URL_BEFORE_ISREAD + "true" + READ_URL_BEFORE_MOBILE + mobile_ + READ_URL_BEFORE_SHORTCODE_END + shortCode
            
        case .sms_Factory:
            finalUrl = URL_SMS_FACTORY + READ_URL_BEFORE_SERIAL + serial + READ_URL_BEFORE_UUID + uuid + READ_URL_BEFORE_ISREAD + "true" + READ_URL_BEFORE_MOBILE + mobile_ + READ_URL_BEFORE_SHORTCODE_END + shortCode
        }
        
        print("===== >>>>> Read Receipt URL = \(finalUrl)")
        
        PostDataWithUrl(urlString:finalUrl, withParameterDictionary:Dictionary(),completionBlock: {(error, response) -> (Void) in
            
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
        let uuid:String = params["uuid"] as! String
        let serial:String = params["serial"] as! String
        let mobile:String = params["mobile"] as! String
        let shortCode:String = params["shortCode"] as! String
        
        var finalUrl = ""
        
        switch environment {
            
        case .texting_Line:
            finalUrl = URL_TEXTING_LINE + CHAT_URL + uuid + CHAT_URL_BEFORE_SERIAL + serial + CHAT_URL_BEFORE_MOBILE + mobile + CHAT_URL_BEFORE_SHORTCODE + shortCode
            
        case .sms_Factory:
            finalUrl = URL_SMS_FACTORY + CHAT_URL + uuid + CHAT_URL_BEFORE_SERIAL + serial + CHAT_URL_BEFORE_MOBILE + mobile + CHAT_URL_BEFORE_SHORTCODE + shortCode
        }
        
        print("===== >>>>> Get Message URL = \(finalUrl)")
        
        PostDataWithUrl(urlString:finalUrl, withParameterDictionary:Dictionary(),completionBlock: {(error, response) -> (Void) in
            
            if (error == nil)
            {
                DispatchQueue.global(qos: .background).async
                    {
                        DispatchQueue.main.async
                            {
                                successBlock(messageParser.parseMessages(json:response as! Dictionary<String, Any>))
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
    static func removeSpecialCharsFromString(_ text: String) -> String
    {
        let okayChars : Set<Character> =
            Set("1234567890")
        return String(text.filter {okayChars.contains($0) })
    }
    
    static func getPostString(params:[String:Any]) -> String
    {
        var data = [String]()
        for(key, value) in params
        {
            data.append(key + "=\(value)")
        }
        return data.map { String($0) }.joined(separator: "&")
    }
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //------------------------------------------------------------------------------------------------//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    static func sendMessage(params: Dictionary<String,Any>, completionBlockSuccess successBlock: @escaping ((Dictionary<String, Any>?) -> (Void)), andFailureBlock failureBlock: @escaping ((Error?) -> (Void)))
    {
        
        var finalUrl = ""
        
        switch environment {
            
        case .texting_Line:
            /*
            //            var theJSONText = ""
            //
            //            if let theJSONData = try? JSONSerialization.data(
            //                withJSONObject: params,
            //                options: []) {
            //                theJSONText = String(data: theJSONData,
            //                                     encoding: .ascii)!
            //            }
            //
            //            let escapedMessageStr = theJSONText.addingPercentEncoding(withAllowedCharacters:.urlHostAllowed)!
            
            finalUrl = URL_TEXTING_LINE // + escapedMessageStr
            */
            let uuid:String = params["uuid"] as! String
            let serial:String = params["serial"] as! String
            let mobile:String = params["mobile"] as! String
            let shortCode:String = params["shortcode"] as! String
            let message:String = params["message"] as! String
            
            //            let ev:String = params["ev"] as! String
            //            let attachment:String = params["attachment"] as! String
            //            let attachmentSuffix:String = params["attachemntFileSuffix"] as! String
            
            let escapedMessageStr :String = message.addingPercentEncoding(withAllowedCharacters:.urlHostAllowed)!
            
            finalUrl = URL_TEXTING_LINE + SEND_URL + uuid + SEND_URL_BEFORE_SERIAL + serial + SEND_URL_BEFORE_MOBILE + mobile + SEND_URL_BEFORE_SHORTCODE + shortCode + SEND_URL_BEFORE_MESSAGE + escapedMessageStr //+ SEND_URL_BEFORE_IMAGETYPE + attachmentSuffix + SEND_URL_BEFORE_IMAGE + attachment
            
        case .sms_Factory:
            let uuid:String = params["uuid"] as! String
            let serial:String = params["serial"] as! String
            let mobile:String = params["mobile"] as! String
            let shortCode:String = params["shortcode"] as! String
            let message:String = params["message"] as! String

            //            let ev:String = params["ev"] as! String
            //            let attachment:String = params["attachment"] as! String
            //            let attachmentSuffix:String = params["attachemntFileSuffix"] as! String
            
            let escapedMessageStr :String = message.addingPercentEncoding(withAllowedCharacters:.urlHostAllowed)!
            
            finalUrl = URL_SMS_FACTORY + SEND_URL + uuid + SEND_URL_BEFORE_SERIAL + serial + SEND_URL_BEFORE_MOBILE + mobile + SEND_URL_BEFORE_SHORTCODE + shortCode + SEND_URL_BEFORE_MESSAGE + escapedMessageStr //+ SEND_URL_BEFORE_IMAGETYPE + attachmentSuffix + SEND_URL_BEFORE_IMAGE + attachment
        }
        
        print("===== >>>>> Send Message URL = \(finalUrl)")
        
        PostDataWithUrl(urlString:finalUrl, withParameterDictionary:params,completionBlock: {(error, response) -> (Void) in
            
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
        let uuid:String = params["uuid"] as! String
        let serial:String = params["serial"] as! String
        var mobile:String = params["mobile"] as! String
        let message:String = params["message"] as! String
        
        mobile = removeSpecialCharsFromString(mobile)
        
        let escapedString :String = message.addingPercentEncoding(withAllowedCharacters:.urlHostAllowed)!
        
        var finalUrl = ""
        
        switch environment {
            
        case .texting_Line:
            finalUrl = URL_TEXTING_LINE + SEND_URL + uuid + SEND_URL_BEFORE_SERIAL + serial + SEND_URL_BEFORE_MOBILE + mobile + SEND_URL_BEFORE_MESSAGE + escapedString
            
        case .sms_Factory:
            finalUrl = URL_SMS_FACTORY + SEND_URL + uuid + SEND_URL_BEFORE_SERIAL + serial + SEND_URL_BEFORE_MOBILE + mobile + SEND_URL_BEFORE_MESSAGE + escapedString
        }
        
        print("===== >>>>> Compose Message URL = \(finalUrl)")
        
        PostDataWithUrl(urlString:finalUrl, withParameterDictionary:Dictionary(),completionBlock: {(error, response) -> (Void) in
            
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
        var theJSONText = ""
        
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: params,
            options: []) {
            theJSONText = String(data: theJSONData,
                                 encoding: .ascii)!
        }
        
        let escapedString :String = theJSONText.addingPercentEncoding(withAllowedCharacters:.urlHostAllowed)!
        
        
        var finalUrl = ""
        
        switch environment {
            
        case .texting_Line:
            finalUrl = URL_TEXTING_LINE + CREATE_APPOINMENT_URL + escapedString
            
        case .sms_Factory:
            finalUrl = URL_SMS_FACTORY + CREATE_APPOINMENT_URL + escapedString
        }
        
        print("===== >>>>> Create Appoinment URL = \(finalUrl)")
        
        PostDataWithUrl(urlString:finalUrl, withParameterDictionary:Dictionary(),completionBlock: {(error, response) -> (Void) in
            
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
    internal static func PostDataWithUrl (urlString: String, withParameterDictionary parameters: Dictionary<String,Any>, completionBlock completion: @escaping ((_ error : Error?, _ response : NSDictionary?) -> (Void))) {
        
        if Reachability.isInternetAvailable()
        {
            
            let request : NSMutableURLRequest = NSMutableURLRequest.init(url: NSURL.init(string: urlString)! as URL, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 35)
            
            request.httpMethod = "POST"
            
            do
            {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
//                let postString = self.getPostString(params: parameters)
//                request.httpBody = postString.data(using: .utf8)
//                print("===== ===== >>>>> Request HTTP Body <<<<< ===== ====== \(String(describing: request.httpBody))")
            }
            catch let error
            {
                print(error.localizedDescription)
            }
            
            request.setValue(/*"application/json"*/"application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let dataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                
                guard error == nil else
                {
                    return
                }
                
                guard let data = data else
                {
                    return
                }
                
                let responseStrInISOLatin = String(data: data, encoding: String.Encoding.isoLatin1)
                
                guard let modifiedDataInUTF8Format = responseStrInISOLatin?.data(using: String.Encoding.utf8)
                    else
                {
                    completion(NSError(domain: "com.mpos.tlt", code: 400, userInfo: [NSLocalizedDescriptionKey : WebManager.Server_Not_Responding]),nil)
                    
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
                        completion(NSError(domain: "com.mpos.tlt", code: 400, userInfo: [NSLocalizedDescriptionKey : WebManager.Server_Not_Responding]),nil)
                    }
                }
                catch
                {
                    print(error.localizedDescription)
                    
                    let code = (error as NSError).code
                    
                    if(code == 3840)
                    {
                        completion(NSError(domain: "com.mpos.tlt", code: 3840, userInfo: [NSLocalizedDescriptionKey : WebManager.Invalid_Json_Format]),nil)
                    }
                    else
                    {
                        completion(error,nil);
                    }
                }
            })
            dataTask.resume()
            
        }else{
            completion(NSError(domain: "com.mpos.tlt", code: 400, userInfo: [NSLocalizedDescriptionKey : WebManager.Check_Internet_Question]),nil)
        }
        
    }
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //------------------------------------------------------------------------------------------------//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
}
//************************************************************************************************//
//------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------//
//************************************************************************************************//
