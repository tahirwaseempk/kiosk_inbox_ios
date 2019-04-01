import UIKit
import SwiftyPickerPopover

class ScheduleAppointmentViewController: UIViewController
{
    
    @IBOutlet var calendarView: GCCalendarView!
    
    @IBOutlet weak var calendarLabel: UILabel!
    @IBOutlet weak var whiteBackgroundView: UIView!
    @IBOutlet weak var scheduleAppointmentButton: UIButton!
    @IBOutlet weak var dateControlsContainer: UIView!
    @IBOutlet weak var calendarLogoButton: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var messageTextView: UITextView!

    var selectedConversation:Conversation! = nil
    
    var headerTitleString = ""
    
    var checkBoxMessage = "Reminder"
    
    var reminderSelectedDate = Date()
    var reminderTimeInterval = TimeInterval()
    
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    
    @IBAction func hourButton_Tapped(_ sender: UIButton) {
        // CountdownPickerPopover appears:
        CountdownPickerPopover(title: "")
            .setSelectedTimeInterval(self.reminderTimeInterval)
            .setValueChange(action: { _, timeInterval in
                print("current interval \(timeInterval)")
            })
            .setDoneButton(action: { popover, timeInterval in
                print("timeInterval \(timeInterval)")
                
             self.reminderTimeInterval = timeInterval
             self.hourLabel.text =  timeInterval.hoursFromTimeInterval()
             self.minuteLabel.text =  timeInterval.minutesFromTimeInterval()
                
            })
            .setCancelButton(action: { _, _ in print("cancel")})
            .setClearButton(action: { popover, timeInterval in print("Clear")
                popover.setSelectedTimeInterval(TimeInterval()).reload()
            })
            .appear(originView: sender, baseViewController: self)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
//        self.headerLabel.text =  self.splitNumber(str: self.headerTitleString)// "Schedule Appointment with " + self.headerTitleString
        
        self.headerLabel.textColor = AppThemeColor
        
        if self.selectedConversation.receiver?.firstName?.isEmpty == false && self.selectedConversation.receiver?.lastName?.isEmpty == false
        {
            self.headerLabel.text = (self.selectedConversation.receiver?.firstName)! + " " + (self.selectedConversation.receiver?.lastName)!
        }
        else
        {
            self.headerLabel.text = (self.selectedConversation.receiver?.phoneNumber)!
            
        }
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.calendar = NSCalendar.current
        
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "dd MMM, yyyy", options: 0, locale: dateFormatter.calendar.locale)
        
        self.calendarLabel.text = dateFormatter.string(from: Date())
        
        self.whiteBackgroundView.layer.cornerRadius =  self.whiteBackgroundView.frame.size.width / 25.0
        
        self.scheduleAppointmentButton.layer.cornerRadius =  self.scheduleAppointmentButton.frame.size.width / 30.0
        
        self.dateControlsContainer.layer.borderWidth = 1.0
        
        self.dateControlsContainer.layer.borderColor = UIColor.lightGray.cgColor
        
        self.calendarLogoButton.layer.borderWidth = 1.0
        
        self.calendarLogoButton.layer.borderColor = UIColor.lightGray.cgColor
        
        scheduleAppointmentButton.backgroundColor = AppThemeColor
        scheduleAppointmentButton.setTitleColor(UIColor.white, for: UIControlState.normal)
    
        messageTextView.delegate = self
        messageTextView.text = "Enter your message"
        messageTextView.textColor = UIColor.lightGray
        messageTextView.layer.sublayerTransform = CATransform3DMakeTranslation(4, 0, 0)
        messageTextView.textContainer.lineBreakMode = NSLineBreakMode.byWordWrapping
        messageTextView.isScrollEnabled = false
        
//        self.inputCharacterCountLabel.text = "Characters Count 0/250"
        
    }
    
    
    
    @IBAction func dismisButtonTapped(_ sender: Any)
    {
        self.view.removeFromSuperview()
        
    }
    
    @IBAction func scheduleButtonTapped(_ sender: Any)
    {
        //--------------------------------------------------------------------------------//
        if ((messageTextView.text == "Enter your message") ||
            (messageTextView.text.count == 0)) {
            
            let alert = UIAlertController(title: "Error", message: "Please enter message.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        //--------------------------------------------------------------------------------//

        
        /////////////////////////////////////////////////////////////////////////////////////
        let hoursWithoutMString = hourLabel.text!
        let minutesWithoutMString = minuteLabel.text!
        /////////////////////////////////////////////////////////////////////////////////////
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.dateFormat = ONLY_DATE
        var selectedDateStr = dateFormatter.string(from: self.reminderSelectedDate)
        /////////////////////////////////////////////////////////////////////////////////////
        selectedDateStr = selectedDateStr + " " + hoursWithoutMString + ":" + minutesWithoutMString  + ":00"
        /////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        let currentDte = Date()
        dateFormatter.dateFormat = DATE_FORMATE_APP
        let currentDateStr = dateFormatter.string(from: currentDte)
        let currentDate = dateFormatter.date(from: currentDateStr)
        /////////////////////////////////////////////////////////////////////////////////////
        let selectedFullDate = dateFormatter.date(from: selectedDateStr)!
        //--------------------------------------------------------------------------------//
        if selectedFullDate.compare(currentDate!) == .orderedAscending {
            let alert = UIAlertController(title: "Error", message: "Selected date or time is in the past.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        /////////////////////////////////////////////////////////////////////////////////////
        //--------------------------------------------------------------------------------//
        let utcFormatter = DateFormatter()
        utcFormatter.dateFormat = UTC_DATE_TIME_APPOINTMENT
        utcFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let utcTimeZoneStr = utcFormatter.string(from: selectedFullDate)
        //--------------------------------------------------------------------------------//
        /////////////////////////////////////////////////////////////////////////////////////

        /////////////////////////////////////////////////////////////////////////////////////
        /////////////////////////////////////////////////////////////////////////////////////
        /////////////////////////////////////////////////////////////////////////////////////
        ProcessingIndicator.show()
        
        var paramsDic = Dictionary<String, Any>()
        paramsDic["contactId"] = selectedConversation.contactId
        paramsDic["date"] = utcTimeZoneStr
        
        let messagetxt = messageTextView.text.replaceAppospherewithAllowableString()

        paramsDic["message"] = messagetxt
        
        User.createAppointment(params:paramsDic , completionBlockSuccess: { (status: Bool) -> (Void) in
            DispatchQueue.global(qos: .background).async
                {
                    DispatchQueue.main.async
                        {
                            if status == true {
                                ProcessingIndicator.hide()
                                let alert = UIAlertController(title: "Success", message: "Reminder created sucessfully.", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
                                    self.view.removeFromSuperview()
                                }))
                                
                                self.present(alert, animated: true, completion: nil)
                            }
                            else
                            {
                                ProcessingIndicator.hide()
                                let alert = UIAlertController(title: "Error", message: "Reminder not created sucessfully.", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                    }
            }
        }, andFailureBlock: { (error: Error?) -> (Void) in
            
            DispatchQueue.global(qos: .background).async
                {
                    DispatchQueue.main.async
                        {
                            ProcessingIndicator.hide()
                            let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                    }
            }
        })
        /////////////////////////////////////////////////////////////////////////////////////
        /////////////////////////////////////////////////////////////////////////////////////
        /////////////////////////////////////////////////////////////////////////////////////
    }
    
    
    @IBAction func calendarButtonTapped(_ sender: UIButton)
    {
        DatePickerPopover(title: "")
            .setDateMode(.date)
            .setSelectedDate(Date())
            .setDoneButton(action: { (popOver, selectDate) in
                print(selectDate)
                
                self.reminderSelectedDate = selectDate
                let dateFormatter =  DateFormatter()
                //dateFormatter.timeZone = TimeZone.current
                dateFormatter.dateFormat = "MMM dd, yyyy"
                self.calendarLabel.text = dateFormatter.string(from: self.reminderSelectedDate)
                
            })
            .setCancelButton(action: { _, _ in print("cancel")})
            .appear(originView: sender, baseViewController: self)
        
    }

}


extension ScheduleAppointmentViewController : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.isEmpty {
            textView.text = "Enter your message"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        let str = (textView.text! as NSString).replacingCharacters(in: range, with: text)
        
        let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
        let filtered = text.components(separatedBy: cs).joined(separator: "")
        let isAllowed = (text == filtered)
        
        if isAllowed == false {
            return false
        }
        
        let reminingCount = sendMessageMaxLength - str.count
        
        if reminingCount >= 0 {
           // self.inputCharacterCountLabel.text = "Characters Count " + String(str.count) + "/250"
        }
        
        if str.count > sendMessageMaxLength {
            return false
        }
        
        return true
    }
    
}
