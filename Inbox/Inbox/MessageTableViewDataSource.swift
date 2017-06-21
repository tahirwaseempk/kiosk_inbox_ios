//
//  MessageTableViewDataSource.swift
//  Inbox
//
//  Created by tahir on 20/06/2017.
//  Copyright © 2017 Amir Akram. All rights reserved.
//

import Foundation
import UIKit

class MessageTableViewDataSource:NSObject,UITableViewDelegate,UITableViewDataSource {

    let targetedTableView: UITableView
    
    var selectedConversation:ConversationDataModel? = nil

    init(tableview:UITableView) {
        
        self.targetedTableView = tableview
        
        super.init()
        
        self.targetedTableView.dataSource = self
        
        self.targetedTableView.delegate = self
        
        //self.targetedTableView.estimatedRowHeight = 40.0
        
        //self.targetedTableView.rowHeight = UITableViewAutomaticDimension
        
        
    self.targetedTableView.register(UINib(nibName:"MessageTableViewSenderCell",bundle:nil),forCellReuseIdentifier:"MessageTableViewSenderCell")

    }

    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        guard (selectedConversation == nil) else {
             return (selectedConversation?.messages.count)!
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier:"MessageTableViewSenderCell",for:indexPath) as! MessageTableViewSenderCell
        
        cell.selectionStyle  = .none
        
        let message:MessagesDataModel = (selectedConversation?.messages[indexPath.row])!
        
        cell.numberLabel.text = message.mobile
        cell.timeLabel.text = message.date
        cell.messageTextLabel.text = message.message
        
        return cell
    }
    
    func tableView(_ tableView:UITableView,didSelectRowAt indexPath:IndexPath)
    {
        
    }
    
    func loadConversation(conversation_:ConversationDataModel) -> Bool {
        
        self.selectedConversation = conversation_;
        self.targetedTableView.reloadData()
        
        return true
    }
}
