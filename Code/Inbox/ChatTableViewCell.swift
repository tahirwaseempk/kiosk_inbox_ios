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
        
        self.messageLabel.text = text
        self.dateLabel.text    = dateTime
        
        self.messageLabel.sizeToFit()
        self.messageLabel.isScrollEnabled = false
        
        if type == .ChatCellAuthorTypeSender {
            
            self.leadingConstraint.isActive = true
            self.trailingConstraint.isActive = false

            self.leadingContraintEqual.isActive = false
            self.trailingContraintEqual.isActive = true
            
            self.messageLabel.textAlignment = .left

            self.leadingConstraint.constant = self.frame.size.width/2.5
            
            if environment == .text_Attendant {
                
                self.bubbleImageView.tintColor = TextAttendantColor
                self.messageLabel.textColor = UIColor.white
                self.dateLabel.textColor    = UIColor.white
                
                changeImage(imageName: "chat_bubble_sent", imageMode: .alwaysTemplate)
                
            } else if environment == .photo_Texting {
                self.bubbleImageView.tintColor = AppThemeColor
                self.messageLabel.textColor = UIColor.white
                self.dateLabel.textColor    = UIColor.white

                changeImage(imageName: "chat_bubble_sent", imageMode: .alwaysTemplate)
                
            } else {
                self.messageLabel.textColor = UIColor.white
                self.dateLabel.textColor    = UIColor.white
                
                changeImage(imageName: "chat_bubble_sent", imageMode: .alwaysOriginal)
            }
            
           
            
        } else {
            
            self.leadingConstraint.isActive = false
            self.trailingConstraint.isActive = true
           
            self.leadingContraintEqual.isActive = true
            self.trailingContraintEqual.isActive = false
            
            self.trailingConstraint.constant = self.frame.size.width/2.5

            self.messageLabel.textAlignment = .left
            
            self.messageLabel.textColor = UIColor.black
            self.dateLabel.textColor    = UIColor.black
            
            changeImage(imageName: "chat_bubble_received", imageMode: .alwaysOriginal)

        }
        
    }
    
    
    func changeImage(imageName: String, imageMode: UIImage.RenderingMode) {
        
        if let image = UIImage(named: imageName)
        {
            bubbleImageView.image = image
                .resizableImage(withCapInsets:
                    UIEdgeInsets(top: 17, left: 21, bottom: 17, right: 21),
                                resizingMode: .stretch)
                .withRenderingMode(imageMode)
            
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
