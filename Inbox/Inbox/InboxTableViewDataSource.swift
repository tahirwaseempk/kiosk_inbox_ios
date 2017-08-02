//
//  MessageTableViewDataSource.swift
//  Inbox
//
//  Created by Amir Akram on 21/06/2017.
//  Copyright © 2017 Amir Akram. All rights reserved.
//

import Foundation
import UIKit

class InboxTableViewDataSource:NSObject,UITableViewDelegate,UITableViewDataSource {
    
    let targetedTableView: UITableView
    
    var conversations:Array<ConversationDataModel>? = nil
    
    var delegate:InboxTableViewCellProtocol
    
    init(tableview:UITableView, conversations_:Array<ConversationDataModel>, delegate_:InboxTableViewCellProtocol) {
        
        self.targetedTableView = tableview
        
        self.conversations = conversations_
        self.delegate = delegate_
        
        super.init()
        
        self.targetedTableView.dataSource = self
        
        self.targetedTableView.delegate = self
        
        //self.targetedTableView.estimatedRowHeight = 40.0
        //self.targetedTableView.rowHeight = UITableViewAutomaticDimension
        //self.targetedTableView.estimatedSectionHeaderHeight = 2.0
        
        self.targetedTableView.register(UINib(nibName:"InboxTableViewCell",bundle:nil),forCellReuseIdentifier:"InboxTableViewCell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (conversations!.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier:"InboxTableViewCell",for:indexPath) as! InboxTableViewCell
        
        let conversation:ConversationDataModel = conversations![indexPath.row]
        
//        cell.selectionStyle  = .none
        cell.selectionStyle = .blue;

        if let message = conversation.messages.last
        {
            cell.titleLabel.text = message.mobile
            cell.detailLabel.text = message.message
            cell.dateLabel.text = message.date
        }
        else
        {
            cell.titleLabel.text = conversation.mobile
            cell.detailLabel.text = "no message"
            cell.dateLabel.text = ""
        }
        
        return cell
    }
    
    func tableView(_ tableView:UITableView,didSelectRowAt indexPath:IndexPath)
    {
        let conversation:ConversationDataModel = conversations![indexPath.row]
        
        //        if (self.delegate != nil) && self.delegate.responds(to: #selector(InboxTableViewCellProtocol.conversationSelected) {
        _ = self.delegate.conversationSelected(conversation: conversation)
        //        }
        
        
    }
}
