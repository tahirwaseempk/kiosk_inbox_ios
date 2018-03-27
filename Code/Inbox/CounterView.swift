import UIKit

class CounterView: UIView
{
    @IBOutlet weak var valueLabel: UILabel!
    
    @IBInspectable var postfixString:String = ""
    
    @IBInspectable var maxValue:Int = 0
    
    @IBInspectable var minValue:Int = 0
    
    @IBOutlet weak var incrementerButton: UIButton!
    
    @IBOutlet weak var decrementerButton: UIButton!
    
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
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.valueLabel.tag = self.minValue
        
        self.valueLabel.text = String(self.minValue) + postfixString
        
        self.incrementerButton.layer.borderWidth = 1.0
        
        self.incrementerButton.layer.borderColor = UIColor.lightGray.cgColor

        self.decrementerButton.layer.borderWidth = 1.0
        
        self.decrementerButton.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func initSubviews()
    {
        let nib = UINib(nibName:"CounterView", bundle: nil)
        
        nib.instantiate(withOwner: self, options: nil)
        
        containerView.frame = bounds
        
        containerView.layer.borderWidth = 1.0
        
        containerView.layer.borderColor = UIColor.lightGray.cgColor

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