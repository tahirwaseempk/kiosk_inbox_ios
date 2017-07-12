import Foundation

class ProcessingIndicator : NSObject, ProcessingIndicatorProtocol
{
    static var activity: ProcessingIndicatorView = ProcessingIndicatorView()
    
    static func show()
    {
        activity.addActivity()
    }
    
    static func showForDuration(duration: Double)
    {
        activity.addActivity()
        
        self.perform(#selector(hide), with: nil, afterDelay: duration)
    }
    
    static func hide()
    {
        activity.removeActivity()
    }
}
