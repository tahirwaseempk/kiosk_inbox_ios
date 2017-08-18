import UIKit

let LOGIN_URL = "https://mcpn.us/limeApi?ev=kioskInbox&serial="
let LOGIN_URL_END = "&uuid="

//let OPTOUT_URL_BEFORE_UDID = "https://mcpn.us/limeApi?ev=kioskInboxOptOut&json={%22uuid%22:%22"
let OPTOUT_URL_BEFORE_UDID = "https://mcpn.us/limeApi?ev=kioskInboxOptOut&json="
let OPTOUT_URL_BEFORE_SERIAL = "%22,%22serial%22:%22"
let OPTOUT_URL_BEFORE_IDS = "%22,%22mobile%22:%22"
let OPTOUT_URLEND = "%22}"

let CHAT_URL = "https://mcpn.us/limeApi?ev=kioskChatMessages&uuid="
let CHAT_URL_BEFORE_SERIAL = "&serial="
let CHAT_URL_BEFORE_MOBILE = "&mobile="
let CHAT_URL_BEFORE_SHORTCODE = "&shortcode="

let SEND_URL = "https://mcpn.us/limeApi?ev=kioskSendMessage&uuid="
let SEND_URL_BEFORE_SERIAL = "&serial="
let SEND_URL_BEFORE_SHORTCODE = "&shortcode="
let SEND_URL_BEFORE_MOBILE = "&mobile="
let SEND_URL_BEFORE_MESSAGE_END = "&message="

let CONVERSATION_URL = "https://mcpn.us/limeApi?ev=kioskInboxWithDetails&uuid="
let CONVERSATION_URL_END = "&serial="

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
                successBlock(dictionary)
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
        let mobile_ = removeSpecialCharsFromString(mobile)

        let keys: [Any] = ["uuid", "serial", "mobile"]
        let values: [String] = [uuid, serial, mobile_]
        let dict = NSDictionary.init(objects: values, forKeys: keys as! [NSCopying])
       
        var dictFromJSON = Dictionary<String, Any>()
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            
            let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
            // here "decoded" is of type `Any`, decoded from JSON data
            
            // you can now cast it with the right type
             dictFromJSON = (decoded as? [String:String])!

        } catch {
            print(error.localizedDescription)
        }
        
        print(dictFromJSON.description)
        
        
        
        
        
        
//        let str = "https://mcpn.us/limeApi?ev=kioskInboxOptOut&json={\"serial\": \"test-test\", \"mobile\": \"13234593264\", \"uuid\": \"323434234\"}"

        let finalU =  OPTOUT_URL_BEFORE_UDID  + dictFromJSON.description //+ uuid + OPTOUT_URL_BEFORE_SERIAL + serial + OPTOUT_URL_BEFORE_IDS + mobile_ + OPTOUT_URLEND
        
        let finalUrl :String = finalU.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)!

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
            Set("1234567890".characters)
        return String(text.characters.filter {okayChars.contains($0) })
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
        var mobile:String = params["mobile"] as! String
        let shortCode:String = params["shortCode"] as! String
        let message:String = params["message"] as! String

       mobile = removeSpecialCharsFromString(mobile)
        
        let escapedString :String = message.addingPercentEncoding(withAllowedCharacters:.urlHostAllowed)!

        let finalurl = SEND_URL + uuid + SEND_URL_BEFORE_SERIAL + serial + SEND_URL_BEFORE_MOBILE + mobile + SEND_URL_BEFORE_SHORTCODE + "71441-US" + SEND_URL_BEFORE_MESSAGE_END + escapedString
        
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
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
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
                        completion(NSError(domain: "com.mpos.tlt", code: 400, userInfo: [NSLocalizedDescriptionKey : WebManager.Invalid_Json_Format]),nil)
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
