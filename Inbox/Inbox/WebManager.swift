import UIKit

let INBOX_URL = "https://mcpn.us/limeApi?ev=kioskInbox&serial=test-test&uuid=323434234"



class WebManager: NSObject
{
    static let Check_Internet_Question  = "Please Check your Internet Connection"
    static let Invalid_Json_Format      = "Invalid Json Format"
    static let Server_Not_Responding    = "Server is not responding"
    
    //static let WebManagerSharedInstance = WebManager.init();
    
    override init()
    {
        super.init()
    }
    
    static func requestLogin(params: Dictionary<String,Any>, completionBlockSuccess successBlock: @escaping ((AnyObject?) -> (Void)), andFailureBlock failureBlock: @escaping ((Error?) -> (Void)))
    {
        PostDataWithUrl(urlString:INBOX_URL, withParameterDictionary:Dictionary(),completionBlock: {(error, response) -> (Void) in
            
            if (error == nil)
            {
                successBlock(response)
            }
            else
            {
                failureBlock(error)
            }
        })
    }
    
    internal static func PostDataWithUrl (urlString: String, withParameterDictionary parameters: Dictionary<String,Any>, completionBlock completion: @escaping ((_ error : Error?, _ response : NSDictionary?) -> (Void))) {
        
        if Reachability.is_Network_Reachable()
        {
            let request : NSMutableURLRequest = NSMutableURLRequest.init(url: NSURL.init(string: urlString)! as URL, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 9999)
            
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
}
