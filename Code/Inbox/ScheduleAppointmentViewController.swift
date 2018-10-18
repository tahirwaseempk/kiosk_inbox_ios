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
        
        switch environment {
        case .texting_Line:
            scheduleAppointmentButton.backgroundColor = AppBlueColor
            scheduleAppointmentButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        case .sms_Factory:
            scheduleAppointmentButton.backgroundColor = AppBlueColor
            scheduleAppointmentButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        case .fan_Connect:
            scheduleAppointmentButton.backgroundColor = FanAppColor
            scheduleAppointmentButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        case .photo_Texting:
            scheduleAppointmentButton.backgroundColor = PhotoAppColor
            scheduleAppointmentButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        }
        
        self.addCheckboxSubviews()
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
        ProcessingIndicator.show()
        
        var hoursWithoutMString = String(self.hourCounterView.tempValue) // Does Not Contain m at end like 12
        var minutesWithoutMString = String(self.minuteCounterView.valueLabel.tag) // Does Not Contain m at end like 12
        /////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        let dateFormatter = DateFormatter()
        //        dateFormatter.calendar = NSCalendar.current
        //        let currentTimeZone: TimeZone = TimeZone.current
        //        dateFormatter.timeZone = currentTimeZone
        dateFormatter.dateStyle = .short
        // dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy-MM-dd HH:mm:ss", options: 0, locale: dateFormatter.calendar.locale)
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
        
        //let jsonDate = selectedDateStr + "T" + hoursWithoutMString + ":" + minutesWithoutMString  + ":00Z"
        selectedDateStr = selectedDateStr + " " + hoursWithoutMString + ":" + minutesWithoutMString  + ":00"
        /////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////
        let currentDte = Date()
        dateFormatter.dateFormat = DATE_FORMATE_APP
        let currentDateStr = dateFormatter.string(from: currentDte)
        let currentDate = dateFormatter.date(from: currentDateStr)
        
        let selectedDate : Date = dateFormatter.date(from: selectedDateStr)!
        //--------------------------------------------------------------------------------//
        if selectedDate.compare(currentDate!) == .orderedAscending {
            ProcessingIndicator.hide()
            let alert = UIAlertController(title: "Error", message: "Selected Date/Time is in the past.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        //--------------------------------------------------------------------------------//
        let utcFormatter = DateFormatter()
        utcFormatter.dateFormat = UTC_DATE_TIME
        utcFormatter.timeZone = TimeZone(abbreviation: "UTC")
        var utcTimeZoneStr = utcFormatter.string(from: selectedDate)
        
        utcTimeZoneStr = convertUTCToJsonString(tsString: utcTimeZoneStr)
        //--------------------------------------------------------------------------------//

        // let timeWithHrsString = self.timeCounterView.valueLabel.text // Contains hrs at end like 12hrs
        let timeWithoutHrs = self.timeCounterView.valueLabel.tag // Does Not Contain hrs at end like 12
        
        var paramsDic = Dictionary<String, Any>()
        
        paramsDic["contactId"] = selectedConversation.contactId //Int
        paramsDic["date"] = utcTimeZoneStr
        paramsDic["endDate"] = ""
        paramsDic["reminderTime"] = Int64(timeWithoutHrs) //Int
        paramsDic["message"] = "Appointment"
        //paramsDic["type"] = self.checkBoxMessage // "Reminder" //ShortConfirmation
        
        User.createAppointment(params:paramsDic , completionBlockSuccess: { (status: Bool) -> (Void) in
            DispatchQueue.global(qos: .background).async
                {
                    DispatchQueue.main.async
                        {
                            if status == true {
                                ProcessingIndicator.hide()
                                
                                let alert = UIAlertController(title: "Sucess", message: "Appointment Created Sucessfully.", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
                                    self.view.removeFromSuperview()
                                }))
                                
                                self.present(alert, animated: true, completion: nil)
                            }
                            else
                            {
                                ProcessingIndicator.hide()
                                let alert = UIAlertController(title: "Error", message: "Appointment Not Created Sucessfully.", preferredStyle: UIAlertControllerStyle.alert)
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
    
//    func convertToUTC(dateToConvert: Date) -> String {
//
//        let formatter = DateFormatter()
//        formatter.dateFormat = UTC_DATE_TIME
//        //let convertedDate = formatter.string(from: dateToConvert)
//        formatter.timeZone = TimeZone(identifier: "UTC")
//        return formatter.string(from: dateToConvert)
//
//    }

}

extension ScheduleAppointmentViewController : GCCalendarViewDelegate
{
    func calendarView(_ calendarView: GCCalendarView, didSelectDate date: Date, inCalendar calendar: Calendar)
    {
        let dateFormatter = DateFormatter()
        
        dateFormatter.calendar = NSCalendar.current
        
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "dd MMMM, yyyy", options: 0, locale: calendar.locale)
        
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
