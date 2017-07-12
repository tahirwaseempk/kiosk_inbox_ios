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
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        let view = UIView()
        
        view.backgroundColor = UIColor.red
        
        self.selectedBackgroundView = view
        
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
}
