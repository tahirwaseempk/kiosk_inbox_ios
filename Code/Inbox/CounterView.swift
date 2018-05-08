import UIKit

class CounterView: UIView
{
    @IBOutlet weak var valueLabel: UILabel!
    
    @IBInspectable var postfixString:String = ""
    
    @IBInspectable var maxValue:Int = 0
    
    @IBInspectable var minValue:Int = 0
    
    @IBInspectable var viewType:String = ""
    
    @IBInspectable var tempValue:Int = 1
    
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
        
        if viewType == "hours" {
            self.valueLabel.text = String(12) + postfixString
        }
        else {
            self.valueLabel.text = String(self.minValue) + postfixString
        }
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
        //-------------------------------------------------------------------------------------//
        //-------------------------------------------------------------------------------------//
        if self.viewType == "hours"
        {
            print("<<<<<<<<<< TEMP VALUE: \(self.tempValue) < MAX VALUE: \(self.maxValue) >>>>>>>>>>")
            
            if (self.tempValue < self.maxValue) {

                self.tempValue = self.tempValue + 1
                print("<********** Temp Value: \(self.tempValue) **********>")

                //****************************************************************//
                if (self.tempValue == 0) {
                    
                    self.valueLabel.text = String(12) + " AM"
                    
                } else if 1 ... 11 ~= self.tempValue {
                  
                    self.valueLabel.text = String(self.tempValue) + " AM"
                    
                } else if (self.tempValue == 12) {
                    
                    self.valueLabel.text = String(12) + " PM"
                    
                } else if 13 ... 23 ~= self.tempValue {
                 
                    self.valueLabel.text = String(self.tempValue-12) + " PM"
                }
                //****************************************************************//
            }
            return
        }
        //-------------------------------------------------------------------------------------//
        //-------------------------------------------------------------------------------------//
        
        if self.valueLabel.tag < maxValue
        {
            self.valueLabel.tag = self.valueLabel.tag + 1
            
            self.valueLabel.text = String(self.valueLabel.tag) + postfixString
        }
    }
    
    @IBAction func decrement_Tapped(_ sender: Any)
    {
        //-------------------------------------------------------------------------------------//
        //-------------------------------------------------------------------------------------//
        if self.viewType == "hours"
        {
            
            print("<<<<<<<<<< TEMP VALUE: \(self.tempValue) > MIN VALUE: \(self.minValue) >>>>>>>>>>")

            if (self.tempValue > self.minValue) {
                
                self.tempValue = self.tempValue - 1
                print("<********** Temp Value: \(self.tempValue) **********>")

                //****************************************************************//
                if (self.tempValue == 0) {
                    
                    self.valueLabel.text = String(12) + " AM"
               
                } else if 1 ... 11 ~= self.tempValue {
                    
                    self.valueLabel.text = String(self.tempValue) + " AM"
                    
                } else if (self.tempValue == 12) {
                    
                    self.valueLabel.text = String(12) + " PM"
                    
                } else if 13 ... 24 ~= self.tempValue {
                    
                    self.valueLabel.text = String(self.tempValue-12) + " PM"
                }
                //****************************************************************//
            } 
            return
        }
        //-------------------------------------------------------------------------------------//
        //-------------------------------------------------------------------------------------//
        
        if self.valueLabel.tag >= 1
        {
            self.valueLabel.tag = self.valueLabel.tag - 1
            
            self.valueLabel.text = String(self.valueLabel.tag) + postfixString
        }
    }
    
    
    func amAppend(str:String) -> String
    {
        
        var strArr  = str.split{$0 == " "}.map(String.init)
        
        let postfix = strArr[1]
        
        return String(removeSpecialCharsFromString(postfix))
    }
    
    func removeSpecialCharsFromString(_ str: String) -> String
    {
        struct Constants {
            static let validChars = Set("AMP")
        }
        return String(str.filter { Constants.validChars.contains($0) })
    }
    
    
    
}
