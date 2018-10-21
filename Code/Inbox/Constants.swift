import Foundation

let activityHeight = 60
let activityWidth = 60
let ACTIVITY_VIEW_TAG = 100001
let ACTIVITY_OVERLAY_TAG = 100002

let DATE_FORMATE_STRING = "yyyy/MM/dd HH:mm:ss"
let DISPLAY_FORMATE_STRING = "MM/dd/yyyy hh:mm:ss a"
let DATE_FORMATE_APP = "yyyy-MM-dd h:mm:ss"
let ONLY_DATE = "yyyy-MM-dd"
let UTC_DATE_TIME = "yyyy-MM-dd HH:mm:ss ZZZ"


let sendMessageMaxLength = 250
let PHONENUMBER_MAX_LENGTH = 15
let CODE_MAX_LENGTH = 6

let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_;/?:@=,.-!()$ "
let ACCEPTABLE_DIGITS = "0123456789"

enum environmentType {
    case texting_Line,
    sms_Factory,
    fan_Connect,
    photo_Texting
}

let environment:environmentType = .texting_Line

let AppBlueColor    = UIColor(red: 74/256, green: 144/256, blue: 226/256, alpha: 1.0)
let FanAppColor     = UIColor(red: 87/256, green: 179/256, blue: 181/256, alpha: 1.0)
let PhotoAppColor   = UIColor(red: 141/256, green: 143/256, blue: 199/256, alpha: 1.0)
let GrayHeaderColor = UIColor(red: 206/256, green: 205/256, blue: 210/256, alpha: 1.0)

let TextingHex  = "007AFF"
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


