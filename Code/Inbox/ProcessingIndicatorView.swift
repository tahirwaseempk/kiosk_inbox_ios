import UIKit

@IBDesignable

class ProcessingIndicatorView: UIView
{
    @IBInspectable var hidesWhenStopped : Bool = false
    @IBInspectable var outerFillColor : UIColor = UIColor.clear
    @IBInspectable var outerStrokeColor : UIColor = UIColor.gray
    @IBInspectable var outerLineWidth : CGFloat = 5.0
    @IBInspectable var outerEndStroke : CGFloat = 1.0
    @IBInspectable var outerAnimationDuration : CGFloat = 2.0
    @IBInspectable var enableInnerLayer : Bool = true
    @IBInspectable var innerFillColor : UIColor  = UIColor.clear
    @IBInspectable var innerStrokeColor : UIColor = UIColor(red: 208/255, green: 154/255, blue: 35/255, alpha: 1)
    @IBInspectable var centerImageSize: CGFloat = 50
   
//    @IBInspectable var centerImage: UIImage? = UIImage(named:"ChatLogo.jpg")
    @IBInspectable var centerImage: UIImage? = UIImage(named:"sms_indicator.png")

    @IBInspectable var innerLineWidth : CGFloat = 5.0
    @IBInspectable var innerEndStroke : CGFloat = 0.5
    @IBInspectable var innerAnimationDuration : CGFloat = 1.0
    
    var currentInnerRotation : CGFloat = 0
    var currentOuterRotation : CGFloat = 0
    
    var innerView : UIView = UIView()
    var outerView : UIView = UIView()
    var centerView : UIImageView = UIImageView()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        switch environment {
        case .texting_Line:
            centerImage = UIImage(named:"ChatLogo.jpg")
        case .sms_Factory:
            centerImage = UIImage(named:"sms_indicator.png")
        }
        
        self.commonInit()
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
        
        self.commonInit()
    }
    
    internal func commonInit()
    {
        self.backgroundColor = UIColor.clear
    }
    
    override func draw(_ rect: CGRect)
    {
        self.addSubview(outerView)
        
        outerView.frame = CGRect(x: 0 , y: 0, width: rect.size.width, height: rect.size.height)
        
        outerView.center = self.convert(self.center, from: self.superview!)
        
        let outerLayer = CAShapeLayer()
        
        outerLayer.path = UIBezierPath(ovalIn: outerView.bounds).cgPath
        
        outerLayer.lineWidth = outerLineWidth
        
        outerLayer.strokeStart = 0.0
        
        outerLayer.strokeEnd = outerEndStroke
        
        outerLayer.lineCap = kCALineCapRound
        
        outerLayer.fillColor = outerFillColor.cgColor
        
        outerLayer.strokeColor = outerStrokeColor.cgColor
        
        outerView.layer.addSublayer(outerLayer)
        
        self.addSubview(centerView)
        
        centerView.frame = CGRect(x: 0, y: 0, width: centerImageSize, height: centerImageSize)
        
        centerView.layer.cornerRadius = centerView.frame.width / 2
        
        centerView.clipsToBounds = true
        
        centerView.center = self.convert(self.center, from: self.superview!)
        
        centerView.image = centerImage
        
        if enableInnerLayer
        {
            self.addSubview(innerView)
            
            innerView.frame = CGRect(x: 0 , y: 0, width: rect.size.width , height: rect.size.height)
            
            innerView.center =  self.convert(self.center, from: self.superview!)
            
            let innerLayer = CAShapeLayer()
            
            innerLayer.path = UIBezierPath(ovalIn: innerView.bounds).cgPath
            
            innerLayer.lineWidth = innerLineWidth
            
            innerLayer.strokeStart = 0
            
            innerLayer.strokeEnd = innerEndStroke
            
            innerLayer.lineCap = kCALineCapRound
            
            innerLayer.fillColor = innerFillColor.cgColor
            
            innerLayer.strokeColor = innerStrokeColor.cgColor
            
            innerView.layer.addSublayer(innerLayer)
        }
        
        self.startAnimating()
    }
    
    internal func animateInnerRing()
    {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        
        rotationAnimation.fromValue = 0 * CGFloat(Double.pi/180)
        
        rotationAnimation.toValue = 360 * CGFloat(Double.pi/180)
        
        rotationAnimation.duration = Double(innerAnimationDuration)
        
        rotationAnimation.repeatCount = HUGE
        
        self.innerView.layer.add(rotationAnimation, forKey: "rotateInner")
    }
    
    internal func startAnimating()
    {
        self.isHidden = false
        
        self.animateInnerRing()
    }
    
    func addActivity()
    {
        self.frame = CGRect(origin: returnCentrePosition(bounds: (UIApplication.shared.keyWindow?.bounds)!), size: CGSize(width: activityWidth, height: activityHeight))

        self.tag = ACTIVITY_VIEW_TAG
        
        self.hidesWhenStopped = true
        
        let overlay = UIView(frame: (UIApplication.shared.keyWindow?.bounds)!)
        
        overlay.tag = ACTIVITY_OVERLAY_TAG
        
        overlay.backgroundColor = UIColor.gray
        
        overlay.alpha = 0.6
        
        UIApplication.shared.keyWindow?.addSubview(overlay)
        
        UIApplication.shared.keyWindow?.addSubview(self)
        
        self.startAnimating()
    }
    
    func removeActivity()
    {
        var activityRemoved:Bool = false
        
        var overlayRemoved:Bool = false
        
        for view in (UIApplication.shared.keyWindow?.subviews)!
        {
            if (view.tag == ACTIVITY_VIEW_TAG)
            {
                let activity = view as! ProcessingIndicatorView
                
                activity.stopAnimating()
                
                activity.removeFromSuperview()
                
                activityRemoved = true
                
            }
            else if (view.tag == ACTIVITY_OVERLAY_TAG)
            {
                view.removeFromSuperview()
                
                overlayRemoved = true
            }
            else if (activityRemoved == true && overlayRemoved == true)
            {
                break
            }
        }
    }
    
    internal func returnCentrePosition(bounds :CGRect) -> CGPoint
    {
        let x =  Int(bounds.width / 2) - (activityWidth / 2)
        
        let y = Int(bounds.height / 2) - (activityHeight / 2)
        
        return CGPoint(x: x, y: y)
    }
    
    func addActivity(parentView : UIView)
    {
        self.frame = CGRect(origin: returnCentrePosition(bounds: parentView.bounds), size: CGSize(width: activityWidth, height: activityHeight))
        
        self.tag = ACTIVITY_VIEW_TAG
        
        self.hidesWhenStopped = true
        
        let overlay = UIView(frame: parentView.frame)
        
        overlay.tag = ACTIVITY_OVERLAY_TAG
        
        overlay.backgroundColor = UIColor.gray
        
        parentView.addSubview(overlay)
        
        parentView.addSubview(self)
        
        overlay.alpha = 0.6
    }
    
    func removeActivity(parentView : UIView)
    {
        var activityRemoved:Bool = false
        
        var overlayRemoved:Bool = false
        
        for view in parentView.subviews
        {
            if (view.tag == ACTIVITY_VIEW_TAG)
            {
                let activity = view as! ProcessingIndicatorView
                
                activity.stopAnimating()
                
                activity.removeFromSuperview()
                
                activityRemoved = true
            }
            else if (view.tag == ACTIVITY_OVERLAY_TAG)
            {
                view.removeFromSuperview()
                
                overlayRemoved = true
            }
            else if (activityRemoved == true && overlayRemoved == true)
            {
                break
            }
        }
    }
    
    internal func stopAnimating()
    {
        if hidesWhenStopped
        {
            self.isHidden = true
        }
        
        self.outerView.layer.removeAllAnimations()
        
        self.innerView.layer.removeAllAnimations()
    }
}
