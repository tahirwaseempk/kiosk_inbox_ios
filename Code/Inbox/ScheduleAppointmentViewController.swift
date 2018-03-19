import UIKit

class ScheduleAppointmentViewController: UIViewController
{
    @IBOutlet var calendarView: CalendarView!
    
    @IBOutlet weak var calendarLabel: UILabel!
    @IBOutlet weak var hourCounterView: CounterView!
    @IBOutlet weak var minuteCounterView: CounterView!
    @IBOutlet weak var timeCounterView: CounterView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    @IBAction func dismisButtonTapped(_ sender: Any)
    {
        self.view.removeFromSuperview()
    }
    
    @IBAction func scheduleButtonTapped(_ sender: Any)
    {
        
    }
    
    @IBAction func calendarButtonTapped(_ sender: UIButton)
    {
        let width = self.view.frame.size.width - 20
        
        self.calendarView.frame = CGRect(x: 0, y: 0, width: width, height: width)
        let options = [
            .type(.down),
            .cornerRadius(1 / 1),
            .animationIn(0.3),
            .blackOverlayColor(UIColor.clear),
            .arrowSize(CGSize(width: 10, height: 10))
            ] as [PopoverOption]
        
        let popover = Popover(options: options, showHandler: nil, dismissHandler: nil)
        
        self.calendarView.backgroundColor = .red
        popover.show(self.calendarView, fromView: sender)
    }
}
