import Foundation

let activityHeight = 60
let activityWidth = 60
let ACTIVITY_VIEW_TAG = 100001
let ACTIVITY_OVERLAY_TAG = 100002

let DATE_FORMATE_STRING = "MM/dd/yyyy hh:mm:ss a"

let sendMessageMaxLength = 250

let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_;/?:@=&,.-!()$ "

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
let EMOJI = "false"
let CONTACTSWITHCHAT = "true"
//c8c176a0ed82274194f917b82b4df907714079959b88c0a3dea53eb2e8014750 FanConnect
