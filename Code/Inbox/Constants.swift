import Foundation

let activityHeight = 60
let activityWidth = 60
let ACTIVITY_VIEW_TAG = 100001
let ACTIVITY_OVERLAY_TAG = 100002

let DATE_FORMATE_STRING = "MM/dd/yyyy hh:mm:ss a"


let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_;/?:@=&,.-!()$ "

enum environmentType {
    case texting_Line,
    sms_Factory,
    fan_Connect,
    photo_Texting
}

let environment:environmentType = .photo_Texting

let AppBlueColor = UIColor(red: 74/256, green: 144/256, blue: 226/256, alpha: 1.0)

let FanAppColor = UIColor(red: 87/256, green: 179/256, blue: 181/256, alpha: 1.0)

let PhotoAppColor = UIColor(red: 141/256, green: 143/256, blue: 199/256, alpha: 1.0)

let GrayHeaderColor = UIColor(red: 194/256, green: 194/256, blue: 194/256, alpha: 1.0)


let sendMessageMaxLength = 250

