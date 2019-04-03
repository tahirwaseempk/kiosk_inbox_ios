import Foundation
import UIKit

let activityHeight = 60
let activityWidth = 60
let ACTIVITY_VIEW_TAG = 100001
let ACTIVITY_OVERLAY_TAG = 100002

let DATE_FORMATE_STRING = "yyyy/MM/dd HH:mm:ss"
let DISPLAY_FORMATE_STRING = "MM/dd/yyyy hh:mm:ss a"
let DATE_FORMATE_APP = "yyyy-MM-dd HH:mm:ss"
let ONLY_DATE = "yyyy-MM-dd"
let DOB_FORMATE = "MM/dd/yyyy"

let UTC_DATE_TIME_AM_PM = "yyyy-MM-dd hh:mm:ss a Z"

let UTC_DATE_TIME_TZ = "yyyy-MM-dd'T'HH:mm:ssZ"
let UTC_DATE_TIME_APPOINTMENT = "yyyy-MM-dd'T'HH:mm:ss'Z'"

let SCHEDULE_DATE_FORMATE = "dd MMM, yyyy"

let sendMessageMaxLength = 250
let PHONENUMBER_MAX_LENGTH = 15
let CODE_MAX_LENGTH = 6

let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789`~!@#%^&*()_+=-[]{};:,./?><' "
let ACCEPTABLE_DIGITS = "0123456789"

enum environmentType {
    case texting_Line,
    sms_Factory,
    fan_Connect,
    photo_Texting,
    text_Attendant
}

let environment:environmentType = .text_Attendant

var AppBlueColor    = UIColor(red: 74/256, green: 144/256, blue: 226/256, alpha: 1.0)
let FanAppColor     = UIColor(red: 87/256, green: 179/256, blue: 181/256, alpha: 1.0)
let PhotoAppColor   = UIColor(red: 141/256, green: 143/256, blue: 199/256, alpha: 1.0)
let TextAttendantColor = UIColor(red: 255/256, green: 80/256, blue: 1/256, alpha: 1.0)

let GrayHeaderColor = UIColor(red: 206/256, green: 205/256, blue: 210/256, alpha: 1.0)

var AppThemeColor = UIColor(red: 74/256, green: 144/256, blue: 226/256, alpha: 1.0)
var AppThemeHex   = "007AFF"

var TextingHex  = "007AFF"
let FanHex      = "56B3B5"
let PhotoHex    = "8D8FC7"
let ReceiverHex = "DFDEE5"

let LIMIT = "0"
let EMOJI = "true"
let CONTACTSWITHCHAT = "false"
//c8c176a0ed82274194f917b82b4df907714079959b88c0a3dea53eb2e8014750 FanConnect

func convertTimeStampToDateString(tsString: String) -> String {
    
    let splitString = tsString.components(separatedBy: "T")
    let datePart = splitString[0]
    var timePart = splitString[1]
    let delCharSet = CharacterSet(charactersIn: "Z")
    timePart = timePart.trimmingCharacters(in: delCharSet as CharacterSet)
    
    return (datePart + " " + timePart)
}

func convertUTCToJsonString(tsString: String) -> String {
    
    let splitString = tsString.components(separatedBy: " ")
    let datePart = splitString[0]
    let timePart = splitString[1]
//    let delCharSet = CharacterSet(charactersIn: "Z")
//    timePart = timePart.trimmingCharacters(in: delCharSet as CharacterSet)
    
    return (datePart + "T" + timePart + "Z")
}


func removeSpecialCharsFromString(_ text: String) -> String
{
    let okayChars : Set<Character> =
        Set("1234567890")
    return String(text.filter {okayChars.contains($0) })
}

func getPostString(params:[String:Any]) -> String
{
    var data = [String]()
    for(key, value) in params
    {
        data.append(key + "=\(value)")
    }
    return data.map { String($0) }.joined(separator: "&")
}

func checkStringForNull(value:AnyObject) -> String
{
    if(value as! NSObject == NSNull() || value as! String == "")
    {
        return ""
    }
    else
    {
        return value as! String
    }
}

func checkIntForNull(value:AnyObject) -> Int64
{
    if(value as! NSObject == NSNull())
    {
        return 0
    }
    else
    {
        return value as! Int64
    }
}

enum LINE_POSITION {
    case LINE_POSITION_TOP
    case LINE_POSITION_BOTTOM
}

let TEXTFIELD_LINE_WIDTH = 0.5


func updateBadgeCount()
{
    //        var badgeCount = UIApplication.shared.applicationIconBadgeNumber
    //        if badgeCount > 0
    //        {
    //            badgeCount = badgeCount-1
    //        }
    
    UIApplication.shared.applicationIconBadgeNumber = 0
}

func addLineToView(view : UIView, position : LINE_POSITION, width: Double) {
    
    let color = AppBlueColor
    
    let lineView = UIView()
    lineView.backgroundColor = color
    lineView.translatesAutoresizingMaskIntoConstraints = false // This is important!
    view.addSubview(lineView)
    
    let metrics = ["width" : NSNumber(value: width)]
    let views = ["lineView" : lineView]
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lineView]|", options:NSLayoutFormatOptions(rawValue: 0), metrics:metrics, views:views))
    
    switch position {
    case .LINE_POSITION_TOP:
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lineView(width)]", options:NSLayoutFormatOptions(rawValue: 0), metrics:metrics, views:views))
        break
    case .LINE_POSITION_BOTTOM:
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[lineView(width)]|", options:NSLayoutFormatOptions(rawValue: 0), metrics:metrics, views:views))
        break
    }
}




// Return IP address of WiFi interface (en0) as a String, or `nil`
func getWiFiAddress() -> String? {
    var address : String?
    
    // Get list of all interfaces on the local machine:
    var ifaddr : UnsafeMutablePointer<ifaddrs>?
    guard getifaddrs(&ifaddr) == 0 else { return nil }
    guard let firstAddr = ifaddr else { return nil }
    
    // For each interface ...
    for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
        let interface = ifptr.pointee
        
        // Check for IPv4 or IPv6 interface:
        let addrFamily = interface.ifa_addr.pointee.sa_family
        if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
            
            // Check interface name:
            let name = String(cString: interface.ifa_name)
            if  name == "en0" {
                
                // Convert interface address to a human readable string:
                var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                            &hostname, socklen_t(hostname.count),
                            nil, socklen_t(0), NI_NUMERICHOST)
                address = String(cString: hostname)
            }
        }
    }
    freeifaddrs(ifaddr)
    
    return address
}

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}


extension String {
    
    func replaceAppospherewithAllowableString()-> String {
        
       return self.replacingOccurrences(of: "’", with: "'")
    }
    
    func containsText(_ text2Search: String)-> Bool {
        
        if self.range(of: text2Search, options: .caseInsensitive) != nil {
            return true
        }
        
        return false
    }
    
}

extension TimeInterval {
    
    func hoursFromTimeInterval() -> String {
        
        let time = NSInteger(self)
        
       // let ms = Int((self.truncatingRemainder(dividingBy: 1)) * 1000)
        //let seconds = time % 60
       //let minutes = (time / 60) % 60
        let hours = (time / 3600)
        
        return String(format: "%0.2d",hours)
    }
    
    func minutesFromTimeInterval() -> String {
        
        let time = NSInteger(self)
        
        // let ms = Int((self.truncatingRemainder(dividingBy: 1)) * 1000)
        //let seconds = time % 60
        let minutes = (time / 60) % 60
        //let hours = (time / 3600)
        
        return String(format: "%0.2d",minutes)
        
    }
}

