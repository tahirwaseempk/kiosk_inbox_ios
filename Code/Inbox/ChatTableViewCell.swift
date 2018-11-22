//
//  ChatTableViewCell.swift
//  ChatCell
//
//  Created by Amir Akram on 09/11/2018.
//  Copyright © 2018 Amir Akram. All rights reserved.
//

import UIKit

enum ChatCellTypeEnum: Int {
    case ChatCellAuthorTypeSender
    case ChatCellAuthorTypeReceiver
}

class ChatTableViewCell: UITableViewCell {

    
    @IBOutlet weak var bubbleImageView: UIImageView!
    @IBOutlet weak var bubbleHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var backgroundCellView: UIView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var messageLabel: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    var cellType : ChatCellTypeEnum = .ChatCellAuthorTypeSender
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    

    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet var leadingConstraint: NSLayoutConstraint!
    @IBOutlet var trailingConstraint: NSLayoutConstraint!
    @IBOutlet var trailingContraintEqual: NSLayoutConstraint!
    @IBOutlet var leadingContraintEqual: NSLayoutConstraint!
    
    func loadCellData (text: String, type: ChatCellTypeEnum, number: String, dateTime: String) {
        
        self.numberLabel.text  = number
        self.messageLabel.text = text
        self.dateLabel.text    = dateTime


        //self.messageLabel.translatesAutoresizingMaskIntoConstraints = true
        self.messageLabel.sizeToFit()
        self.messageLabel.isScrollEnabled = false
        
        //        let contentSize1 = messageLabel.sizeThatFits(messageLabel.bounds.size)

        //        var frame = self.messageLabel.frame
        //        frame.size.height = contentSize1.height
        //        self.messageLabel.frame = frame
        
        if type == .ChatCellAuthorTypeSender {
           
            changeImage("chat_bubble_sent")

            self.leadingConstraint.isActive = true
            self.trailingConstraint.isActive = false
            
            self.trailingContraintEqual.isActive = true
            self.leadingContraintEqual.isActive = false
            
            switch environment {
            case .texting_Line:
                self.bubbleImageView.tintColor = AppBlueColor
                
            case .sms_Factory:
                self.bubbleImageView.tintColor = AppBlueColor
                
            case .fan_Connect:
                self.bubbleImageView.tintColor = FanAppColor

            case .photo_Texting:
                self.bubbleImageView.tintColor = PhotoAppColor
            }
            
            self.messageLabel.textAlignment = .left
            
        } else {
            
            changeImage("chat_bubble_received")

            self.leadingConstraint.isActive = false
            self.trailingConstraint.isActive = true
            self.trailingContraintEqual.isActive = false
            self.leadingContraintEqual.isActive = true

            self.bubbleImageView.tintColor = GrayHeaderColor
            self.messageLabel.textAlignment = .left

        }
        
    }
    
    
    func changeImage(_ name: String) {
        
        if let image = UIImage(named: name)
        {
            bubbleImageView.image = image
             .resizableImage(withCapInsets:
                            UIEdgeInsets(top: 17, left: 21, bottom: 17, right: 21),
                                        resizingMode: .stretch)
                        .withRenderingMode(.alwaysTemplate)

        }
        else
        {
            
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
