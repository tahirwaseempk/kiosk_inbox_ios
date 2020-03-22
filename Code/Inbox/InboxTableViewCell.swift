//
//  MessageTableViewSenderCell.swift
//  Inbox
//
//  Created by Amir Akram on 21/06/2017.
//  Copyright © 2017 Amir Akram. All rights reserved.
//

import UIKit

class InboxTableViewCell: UITableViewCell
{
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var dotImageView: UIImageView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = AppThemeColor
        self.selectedBackgroundView = bgColorView
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
       
        switch environment {
        case .texting_Line:
            self.selectedBackgroundView!.backgroundColor = selected ? AppThemeColor : nil
        case .sms_Factory:
            self.selectedBackgroundView!.backgroundColor = selected ? AppThemeColor : nil
        case .fan_Connect:
            self.selectedBackgroundView!.backgroundColor = selected ? AppThemeColor : nil
        case .photo_Texting:
            self.selectedBackgroundView!.backgroundColor = selected ? AppThemeColor : nil
        case .text_Attendant:
            self.selectedBackgroundView!.backgroundColor = selected ? TextAttendantColor : nil
        }
    }
    
}
