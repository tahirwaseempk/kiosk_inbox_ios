import Foundation

protocol ProcessingIndicatorProtocol
{
    static var activity : ProcessingIndicatorView { get set }
    
    static func show()
    
    static func showForDuration(duration: Double)
    
    static func hide()
}
