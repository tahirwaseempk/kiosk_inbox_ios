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
        
        self.headerLabel.text =  self.headerTitleString// "Schedule Appointment with " + self.headerTitleString
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.calendar = NSCalendar.current
        
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "dd MMMM, yyyy", options: 0, locale: dateFormatter.calendar.locale)
        
        self.calendarLabel.text = dateFormatter.string(from: Date())
        
        self.whiteBackgroundView.layer.cornerRadius =  self.whiteBackgroundView.frame.size.width / 25.0
        
        self.scheduleAppointmentButton.layer.cornerRadius =  self.scheduleAppointmentButton.frame.size.width / 30.0
        
        self.dateControlsContainer.layer.borderWidth = 1.0
        
        self.dateControlsContainer.layer.borderColor = UIColor.lightGray.cgColor
        
        self.calendarLogoButton.layer.borderWidth = 1.0
        
        self.calendarLogoButton.layer.borderColor = UIColor.lightGray.cgColor
        
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
        
        
        
        // let hoursString = self.hourCounterView.valueLabel.text
        let hoursWithoutMString = String(self.hourCounterView.tempValue) // Does Not Contain m at end like 12
        
        // let minutesWithMString = self.minuteCounterView.valueLabel.text // Contains m at end like 12m
        let minutesWithoutMString = String(self.minuteCounterView.valueLabel.tag) // Does Not Contain m at end like 12
        
        /////////////////////////////////////////////////////////////////////////////////////
        //--------------------------------------------------------------------------------//
        ///////////////////////////////////////////////////////////////////////////////////
        let dateFormatter = DateFormatter()
        //        dateFormatter.calendar = NSCalendar.current
        //        let currentTimeZone: TimeZone = TimeZone.current
        //        dateFormatter.timeZone = currentTimeZone
        dateFormatter.dateStyle = .full
        // dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy-MM-dd HH:mm:ss", options: 0, locale: dateFormatter.calendar.locale)
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var dateString = dateFormatter.string(from: self.selectedDate)
        dateString = dateString + " " + hoursWithoutMString + ":" + minutesWithoutMString  //+ ":00"
        
        dateFormatter.dateFormat = "yyyy-MM-dd h:mm"
        let msgDate = dateFormatter.date(from: dateString)
        dateString = dateFormatter.string(from: msgDate!)
        dateString = dateString + ":00"
        /////////////////////////////////////////////////////////////////////////////////////
        //--------------------------------------------------------------------------------//
        ///////////////////////////////////////////////////////////////////////////////////
        
        // let timeWithHrsString = self.timeCounterView.valueLabel.text // Contains hrs at end like 12hrs
        let timeWithoutHrsString = String(self.timeCounterView.valueLabel.tag) // Does Not Contain hrs at end like 12
        
        let mobileNumber = self.selectedConversation.mobile!
        
        var paramsDic = Dictionary<String, Any>()
        
        paramsDic["mobile"] = mobileNumber
        paramsDic["date"] = dateString
        paramsDic["notifyHours"] = timeWithoutHrsString
        paramsDic["first"] = ""
        paramsDic["last"] = ""
        paramsDic["message"] = "Appointment"
        paramsDic["type"] = self.checkBoxMessage // "Reminder" //ShortConfirmation
        
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
}
