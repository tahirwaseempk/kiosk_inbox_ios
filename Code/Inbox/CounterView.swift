import UIKit

class CounterView: UIView
{
    @IBOutlet weak var valueLabel: UILabel!
    
    @IBInspectable var postfixString:String = ""
    
    @IBInspectable var maxValue:Int = 0
    
    @IBInspectable var minValue:Int = 0
    
    @IBOutlet var containerView: CounterView!
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
        
        initSubviews()
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        initSubviews()
    }
    
    func initSubviews()
    {
        let nib = UINib(nibName:"CounterView", bundle: nil)
        
        nib.instantiate(withOwner: self, options: nil)
        
        containerView.frame = bounds
        
        containerView.layer.borderWidth = 1.0
        
        containerView.layer.borderColor = UIColor.darkGray.cgColor
        
        addSubview(containerView)
    }
    
    @IBAction func increment_Tapped(_ sender: Any)
    {
        if self.valueLabel.tag < maxValue
        {
            self.valueLabel.tag = self.valueLabel.tag + 1
        
            self.valueLabel.text = String(self.valueLabel.tag) + postfixString
        }
    }
    
    @IBAction func decrement_Tapped(_ sender: Any)
    {
        if self.valueLabel.tag >= 1
        {
            self.valueLabel.tag = self.valueLabel.tag - 1
            
            self.valueLabel.text = String(self.valueLabel.tag) + postfixString
        }
    }
}
