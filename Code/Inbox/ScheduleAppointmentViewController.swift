import UIKit

class ScheduleAppointmentViewController: UIViewController
{
    @IBOutlet var calendarView: GCCalendarView!
    
    @IBOutlet weak var calendarLabel: UILabel!
    @IBOutlet weak var hourCounterView: CounterView!
    @IBOutlet weak var minuteCounterView: CounterView!
    @IBOutlet weak var timeCounterView: CounterView!
    @IBOutlet weak var whiteBackgroundView: UIView!
    @IBOutlet weak var scheduleAppointmentButton: UIButton!
    @IBOutlet weak var dateControlsContainer: UIView!
    @IBOutlet weak var calendarLogoButton: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var messageTextView: UITextView!

    
    @IBOutlet weak var btnCheckBox: UIButton!
    
    var tickBox:Checkbox? = nil
    
    var selectedConversation:Conversation! = nil
    
    var headerTitleString = ""
    
    var checkBoxMessage = "Reminder"
    
    var selectedDate = Date()
    
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

        /*
        switch environment {
        case .texting_Line:
            scheduleAppointmentButton.backgroundColor = AppThemeColor
            scheduleAppointmentButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        case .sms_Factory:
            scheduleAppointmentButton.backgroundColor = AppThemeColor
            scheduleAppointmentButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        case .fan_Connect:
            scheduleAppointmentButton.backgroundColor = AppThemeColor
            scheduleAppointmentButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        case .photo_Texting:
            scheduleAppointmentButton.backgroundColor = AppThemeColor
            scheduleAppointmentButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        }
         */
        
       // self.addCheckboxSubviews()
    }
    
    func addCheckboxSubviews() {
        
        // tick
        self.tickBox = Checkbox(frame: self.btnCheckBox.bounds)
        self.tickBox?.borderColor = UIColor.black
        self.tickBox?.checkmarkColor = UIColor.black
        self.tickBox?.borderStyle = .square
        self.tickBox?.checkmarkStyle = .tick
        self.tickBox?.checkmarkSize = 0.8
        
        self.tickBox?.addTarget(self, action: #selector(circleBoxValueChanged(sender:)), for: .valueChanged)
        
        self.btnCheckBox.addSubview(self.tickBox!)
    }
    
    @objc func circleBoxValueChanged(sender: Checkbox) {
        
        if sender.isChecked == true {
            self.checkBoxMessage = "ShortConfirmation"
        }
        else {
            self.checkBoxMessage = "Reminder"
        }
        
        print("circle box value change: \(sender.isChecked)")
    }
    
    
    
    @IBAction func dismisButtonTapped(_ sender: Any)
    {
        self.view.removeFromSuperview()
        
    }
    
    @IBAction func scheduleButtonTapped(_ sender: Any)
    {
        
        if ((messageTextView.text == "Enter your message") ||
            (messageTextView.text.count == 0)) {
            
            let alert = UIAlertController(title: "Error", message: "Please enter message.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        
        var hoursWithoutMString = String(self.hourCounterView.tempValue) // Does Not Contain m at end like 12
        var minutesWithoutMString = String(self.minuteCounterView.valueLabel.tag) // Does Not Contain m at end like 12
        /////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.dateFormat = ONLY_DATE
        var selectedDateStr = dateFormatter.string(from: self.selectedDate)
        
        if (minutesWithoutMString == "0") {
            minutesWithoutMString = "00"
        }
        if (hoursWithoutMString == "24") {
            hoursWithoutMString = "23"
        }
        else if (hoursWithoutMString == "0") {
            hoursWithoutMString = "00"
        }
        
        selectedDateStr = selectedDateStr + " " + hoursWithoutMString + ":" + minutesWithoutMString  + ":00"
        /////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        let currentDte = Date()
        dateFormatter.dateFormat = DATE_FORMATE_APP
        let currentDateStr = dateFormatter.string(from: currentDte)
        let currentDate = dateFormatter.date(from: currentDateStr)
        
        let selectedFullDate = dateFormatter.date(from: selectedDateStr)!
        //--------------------------------------------------------------------------------//
        if selectedFullDate.compare(currentDate!) == .orderedAscending {
            let alert = UIAlertController(title: "Error", message: "Selected date or time is in the past.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        //--------------------------------------------------------------------------------//
        let utcFormatter = DateFormatter()
        utcFormatter.dateFormat = UTC_DATE_TIME_APPOINTMENT
        utcFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let utcTimeZoneStr = utcFormatter.string(from: selectedFullDate)
        //utcTimeZoneStr = convertUTCToJsonString(tsString: utcTimeZoneStr)
        //--------------------------------------------------------------------------------//

        //let timeWithoutHrs = self.timeCounterView.valueLabel.tag // Does Not Contain hrs at end like 12
        
        ProcessingIndicator.show()
        
        var paramsDic = Dictionary<String, Any>()
        paramsDic["contactId"] = selectedConversation.contactId //Int
        paramsDic["date"] = utcTimeZoneStr
        //paramsDic["endDate"] = ""
       // paramsDic["reminderTime"] = Int64(timeWithoutHrs) //Int
        paramsDic["message"] = messageTextView.text //"Appointment"
        
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
    }
    
    @IBAction func calendarButtonTapped(_ sender: UIButton)
    {
        self.calendarView.delegate = self
        
        self.calendarView.displayMode = .month
        
        self.view.addSubview(self.calendarView)
        
        let width = self.view.frame.size.width - 40
        
        self.calendarView.frame = CGRect(x: 0, y: 0, width: width, height: width)
        
        let options = [
            .type(.down),
            .cornerRadius(1 / 1),
            .animationIn(0.35),
            .blackOverlayColor(UIColor.clear),
            .arrowSize(CGSize(width: 10, height: 10))
            ] as [PopoverOption]
        
        let popover = Popover(options: options, showHandler: nil, dismissHandler: nil)
        
        popover.show(self.calendarView, fromView: self.calendarLabel)
    }
    
    func removeTimeStamp(fromDate: Date) -> Date {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: fromDate)) else {
            fatalError("Failed to strip time from Date object")
        }
        return date
    }

}

extension ScheduleAppointmentViewController : GCCalendarViewDelegate
{
    func calendarView(_ calendarView: GCCalendarView, didSelectDate date: Date, inCalendar calendar: Calendar)
    {
        let dateFormatter = DateFormatter()
        
        dateFormatter.calendar = NSCalendar.current
        
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "dd MMM, yyyy", options: 0, locale: calendar.locale)
        
        self.calendarLabel.text = dateFormatter.string(from: date)
        
        self.selectedDate = date
    }
    
    func splitNumber(str:String) -> String
    {
        
        var strArr  = str.split{$0 == "-"}.map(String.init)
        //let first = strArr[0]
        var second = ""
        var third = ""
        var fourth = ""
        
        if (strArr.count > 3) {
            second = strArr[1]
            third = strArr[2]
            fourth = strArr[3]
        }
        
        
        let returningStr = second+"-"+third+"-"+fourth
        
        return returningStr
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
