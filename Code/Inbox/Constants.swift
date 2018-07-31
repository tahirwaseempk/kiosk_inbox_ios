import Foundation

let activityHeight = 60
let activityWidth = 60
let ACTIVITY_VIEW_TAG = 100001
let ACTIVITY_OVERLAY_TAG = 100002

let DATE_FORMATE_STRING = "MM/dd/yyyy hh:mm:ss a"


let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_;/?:@=&,.-!()$ "

enum environmentType {
    case texting_Line,
    sms_Factory
}

let environment:environmentType = .sms_Factory

let AppBlueColor = UIColor(red: 74/256, green: 144/256, blue: 226/256, alpha: 1.0)

let sendMessageMaxLength = 250

