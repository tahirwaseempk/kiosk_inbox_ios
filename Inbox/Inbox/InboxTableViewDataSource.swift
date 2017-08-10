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
    
    var conversations:Array<Conversation>? = nil
    
    var delegate:InboxTableViewCellProtocol
    
    init(tableview:UITableView, conversation: NSSet, delegate_:InboxTableViewCellProtocol) {
        
        self.targetedTableView = tableview
        self.conversations = conversation.allObjects as? Array<Conversation>
        self.delegate = delegate_
        
        super.init()
        
        self.targetedTableView.dataSource = self
        self.targetedTableView.delegate = self
        self.targetedTableView.register(UINib(nibName:"InboxTableViewCell",bundle:nil),forCellReuseIdentifier:"InboxTableViewCell")
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (User.getLoginedUser()?.conversations?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier:"InboxTableViewCell",for:indexPath) as! InboxTableViewCell
        
        let conversation:Conversation = User.getLoginedUser()?.conversations?.allObjects [indexPath.row] as! Conversation
        
        cell.selectionStyle = .blue;
        
        if conversation.lastMessage != nil
        {
            cell.titleLabel.text = conversation.mobile
            cell.detailLabel.text = conversation.lastMessage
            cell.dateLabel.text = conversation.conversationDate
        }
        else
        {
            cell.titleLabel.text = conversation.mobile
            cell.detailLabel.text = "no message"
            cell.dateLabel.text = ""
        }
        
        if conversation.isRead == true
        {
            cell.dotImageView.image = UIImage(named: "redCircle.png")
        } else {
            cell.dotImageView.image = nil
            
        }
        
        return cell
    }
    
    func tableView(_ tableView:UITableView,didSelectRowAt indexPath:IndexPath)
    {
        let conversation:Conversation = User.getLoginedUser()?.conversations?.allObjects [indexPath.row] as! Conversation
        _ = self.delegate.conversationSelected(conversation: conversation)
    }
}
