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
        
//        let bgColorView = UIView()
//        bgColorView.backgroundColor = UIColor(red: 81.0, green: 186.0, blue: 251.0, alpha: 1.0)
//        bgColorView.layer.cornerRadius = 15;
        //self.selectedBackgroundView = bgColorView
        
//        self.backgroundView = bgColorView
        
        self.selectedBackgroundView = UIView()
        self.selectionStyle = .default // you can also take this line out
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        self.selectedBackgroundView!.backgroundColor = selected ? UIColor(red: 81.0/255.0, green: 186.0/255.0, blue: 251.0/255.0, alpha: 1.0) : nil

    }
}
