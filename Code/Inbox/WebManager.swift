import UIKit
import Foundation

//mcpn.us

let LOGIN_URL = "https://fct.la/limeApi?ev=kioskInbox&serial="
let LOGIN_URL_END = "&uuid="

let APNS_URL = "https://fct.la/limeApi?ev=kioskAddToken&serial="
let APNS_URL_UDID = "&uuid="
let APNS_URL_TYPE = "&type="
let APNS_URL_TOKEN = "&token="

let OPTOUT_URL_SERIAL = "https://fct.la/limeApi?ev=kioskInboxOptOut&serial="
let OPTOUT_URL_BEFORE_MOBILE = "&mobile="
let OPTOUT_URL_UUID = "&uuid="

let CHAT_URL = "https://fct.la/limeApi?ev=kioskChatMessages&uuid="
let CHAT_URL_BEFORE_SERIAL = "&serial="
let CHAT_URL_BEFORE_MOBILE = "&mobile="
let CHAT_URL_BEFORE_SHORTCODE = "&shortcode="

let SEND_URL = "https://fct.la/limeApi?ev=kioskSendMessage&uuid="
let SEND_URL_BEFORE_SERIAL = "&serial="
let SEND_URL_BEFORE_SHORTCODE = "&shortcode="
let SEND_URL_BEFORE_MOBILE = "&mobile="
let SEND_URL_BEFORE_MESSAGE_END = "&message="

let CONVERSATION_URL = "https://fct.la/limeApi?ev=kioskInboxWithDetails&uuid="
let CONVERSATION_URL_END = "&serial="

let READ_URL_BEFORE_SERIAL = "https://fct.la/limeApi?ev=kioskInboxSetReadByMobile&serial="
let READ_URL_BEFORE_UUID = "&uuid="
let READ_URL_BEFORE_ISREAD = "&isRead="
let READ_URL_BEFORE_MOBILE = "&mobile="
let READ_URL_BEFORE_SHORTCODE_END = "&shortcode="

let DELETE_URL = "https://fct.la/limeApi?ev=kioskInboxDeleteForNumber&uuid="
let DELETE_URL_BEFORE_SERIAL = "&serial="
let DELETE_URL_BEFORE_MOBILE = "&mobile="
let DELETE_URL_BEFORE_SHORTCODE = "&shortcode="

//let CREATE_APPOINMENT_BASE_URL = "https://fct.la/limeApi?ev=kioskInboxCreateAppointment&"
//let CREATE_APPOINMENT_URL = "https://fct.la/limeApi?ev=kioskInboxCreateAppointment&json={"
//let CREATE_APPOINMENT_URL_BEFORE_UUID = "uuid="
//let CREATE_APPOINMENT_URL_BEFORE_SERIAL = "&serial="
//let CREATE_APPOINMENT_URL_BEFORE_MOBILE = "&mobile="
//let CREATE_APPOINMENT_URL_BEFORE_DATE = "&date="
//let CREATE_APPOINMENT_URL_BEFORE_MESSAGE = "&message="
//let CREATE_APPOINMENT_URL_BEFORE_TYPE = "&type="
//let CREATE_APPOINMENT_URL_BEFORE_NOTIFYHOURS = "&notifyHours="
//let CREATE_APPOINMENT_URL_END = "}"

let CREATE_APPOINMENT_URL = "https://fct.la/limeApi?ev=kioskInboxCreateAppointment&json={%22"
let CREATE_APPOINMENT_URL_BEFORE_UUID = "uuid%22:%22"
let CREATE_APPOINMENT_URL_BEFORE_SERIAL = "%22serial%22:%22"
let CREATE_APPOINMENT_URL_BEFORE_MOBILE = "%22mobile%22:%22"
let CREATE_APPOINMENT_URL_BEFORE_DATE = "%22date%22:%22"
let CREATE_APPOINMENT_URL_BEFORE_MESSAGE = "%22message%22:%22"
let CREATE_APPOINMENT_URL_BEFORE_TYPE = "%22type%22:%22"
let CREATE_APPOINMENT_URL_BEFORE_NOTIFYHOURS = "%22notifyHours%22:%22"
let CREATE_APPOINMENT_URL_END = "}"

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
        
        let finalUrl = LOGIN_URL + serial + LOGIN_URL_END + uuid
        
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

        
        
        let finalUrl = APNS_URL + serial + APNS_URL_UDID + uuid + APNS_URL_TYPE + type + APNS_URL_TOKEN + tokenKey
        
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
        
        let finalUrl = CONVERSATION_URL + uuid + CONVERSATION_URL_END + serial
        
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
        
        let finalUrl =  OPTOUT_URL_SERIAL + serial + OPTOUT_URL_BEFORE_MOBILE + mobile + OPTOUT_URL_UUID + uuid
        
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
        
        let finalUrl =  DELETE_URL + uuid + DELETE_URL_BEFORE_SERIAL + serial + DELETE_URL_BEFORE_MOBILE + mobile + DELETE_URL_BEFORE_SHORTCODE + shortCode
        
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
        
        let finalUrl = READ_URL_BEFORE_SERIAL + serial + READ_URL_BEFORE_UUID + uuid + READ_URL_BEFORE_ISREAD + "true" + READ_URL_BEFORE_MOBILE + mobile_ + READ_URL_BEFORE_SHORTCODE_END + shortCode
        
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
        
        let finalUrl = CHAT_URL + uuid + CHAT_URL_BEFORE_SERIAL + serial + CHAT_URL_BEFORE_MOBILE + mobile + CHAT_URL_BEFORE_SHORTCODE + shortCode
        
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
    static func removeSpecialCharsFromString(_ text: String) -> String {
        let okayChars : Set<Character> =
            Set("1234567890")
        return String(text.filter {okayChars.contains($0) })
    }
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //------------------------------------------------------------------------------------------------//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    static func sendMessage(params: Dictionary<String,Any>, completionBlockSuccess successBlock: @escaping ((Dictionary<String, Any>?) -> (Void)), andFailureBlock failureBlock: @escaping ((Error?) -> (Void)))
    {
        let uuid:String = params["uuid"] as! String
        let serial:String = params["serial"] as! String
        let mobile:String = params["mobile"] as! String
        let shortCode:String = params["shortCode"] as! String
        let message:String = params["message"] as! String
        
        //message = message.addingUnicodeEntities
        
        let escapedString :String = message.addingPercentEncoding(withAllowedCharacters:.urlHostAllowed)!
        
        let finalurl = SEND_URL + uuid + SEND_URL_BEFORE_SERIAL + serial + SEND_URL_BEFORE_MOBILE + mobile + SEND_URL_BEFORE_SHORTCODE + shortCode + SEND_URL_BEFORE_MESSAGE_END + escapedString
        
        PostDataWithUrl(urlString:finalurl, withParameterDictionary:Dictionary(),completionBlock: {(error, response) -> (Void) in
            
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
        
        let finalurl = SEND_URL + uuid + SEND_URL_BEFORE_SERIAL + serial + SEND_URL_BEFORE_MOBILE + mobile + SEND_URL_BEFORE_MESSAGE_END + escapedString
        
        PostDataWithUrl(urlString:finalurl, withParameterDictionary:Dictionary(),completionBlock: {(error, response) -> (Void) in
            
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
        let uuid:String = params["uuid"] as! String
        let serial:String = params["serial"] as! String
        let mobile:String = params["mobile"] as! String
        let message:String = params["message"] as! String
        let dateString:String = params["date"] as! String
        let type:String = "Confirmation"//params["date"] as! String
        let notifyHours:String = params["notifyHours"] as! String
        
        let first:String = params["first"] as! String
        let last:String = params["last"] as! String
        let endDate:String = params["endDate"] as! String
        let notifyEmail:String = params["notifyEmail"] as! String
        let notifyNumber:String = params["notifyNumber"] as! String
        
        
        //https://mcpn.us/limeApi?ev=kioskInboxCreateAppointment&json={%22uuid%22:%225aea6597-65c8-4f12-95%20f4-c716a87cd26b%22,%22serial%22:%221111-1111%22,%22mobile%22:%2217326188328%22%20,%22date%22:%222018-05-18%2017:00:00%22,%22message%22:%22appointment%20reminder%20message%22,%22type%22:%22Reminder%22%20,%22notifyHours%22:%203}
        
        
        let finalurl = CREATE_APPOINMENT_URL + CREATE_APPOINMENT_URL_BEFORE_UUID + uuid + CREATE_APPOINMENT_URL_BEFORE_SERIAL + serial + CREATE_APPOINMENT_URL_BEFORE_MOBILE + mobile + CREATE_APPOINMENT_URL_BEFORE_MESSAGE + message + CREATE_APPOINMENT_URL_BEFORE_DATE + dateString + CREATE_APPOINMENT_URL_BEFORE_TYPE + type + CREATE_APPOINMENT_URL_BEFORE_NOTIFYHOURS + notifyHours + CREATE_APPOINMENT_URL_END

        PostDataWithUrl(urlString:finalurl, withParameterDictionary:Dictionary(),completionBlock: {(error, response) -> (Void) in
            
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
            
            let request : NSMutableURLRequest = NSMutableURLRequest.init(url: NSURL.init(string: urlString)! as URL, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 12)
            
            request.httpMethod = "POST"
            
            do
            {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
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
                /*
                 if response?.mimeType == "text/plain"
                 {
                 
                 if ((response?.url?.absoluteString.range(of: "kioskInboxOptOut")) != nil) {
                 
                 let responseData : String = String(data: data, encoding: String.Encoding.utf8)!
                 
                 let statusArr = responseData.components(separatedBy: ":")
                 let statusStr : String = statusArr[0]
                 var messageStr : String = statusArr[1]
                 
                 messageStr = String(messageStr.characters.filter { !" \n".characters.contains($0) })
                 
                 
                 var paramsDic = Dictionary<String, Any>()
                 paramsDic["status"] = statusStr
                 paramsDic["message"] = messageStr
                 
                 completion(nil, paramsDic as NSDictionary)
                 }
                 
                 }
                 */
                //                if let httpResponse:HTTPURLResponse = response as? HTTPURLResponse
                //                {
                //                    let headers = httpResponse.allHeaderFields
                //
                //                    if let sessionString = headers["HTTP"]
                //                    {
                //                        User.sessionHeaderValue = sessionString
                //                    }
                //                }
                
                
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
                
                /*
                do
                {
                    
                    if let Data = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
                    {
                        
                        completion(nil,Data as NSDictionary)
                    }
                    else
                    {
                        completion(NSError(domain: "com.mpos.tlt", code: 400, userInfo: [NSLocalizedDescriptionKey : WebManager.Server_Not_Responding]),nil)
                    }
                }
                catch let error
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
                } */
                
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

