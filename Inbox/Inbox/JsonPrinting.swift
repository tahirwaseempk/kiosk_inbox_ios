import Foundation

extension Dictionary
{
    func printJson()
    {
        let options = JSONSerialization.WritingOptions.prettyPrinted
        
        if JSONSerialization.isValidJSONObject(self)
        {
            let data = try! JSONSerialization.data(withJSONObject:self,options:options)
            
            let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
            
            print(string! as String)
        }
        
    }
}
