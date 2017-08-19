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
    
    var conversations:Array<Conversation> = Array<Conversation>()
    var selectedConversation:Conversation! = nil
    
    var delegate:InboxTableViewCellProtocol
    
    init(tableview:UITableView, conversation: NSSet, delegate_:InboxTableViewCellProtocol) {
        
        self.targetedTableView = tableview
        
        self.delegate = delegate_
        
        super.init()
        
        self.targetedTableView.dataSource = self
        self.targetedTableView.delegate = self
        self.targetedTableView.register(UINib(nibName:"InboxTableViewCell",bundle:nil),forCellReuseIdentifier:"InboxTableViewCell")
        
        self.reloadControls()
    }
    
    func reloadControls()
    {
       conversations = (User.getLoginedUser()?.conversations?.allObjects as? Array<Conversation>)!
        
        //************************************************************************************************//
        //------------------------------------------------------------------------------------------------//
        //************************************************************************************************//
        conversations = conversations.sorted(by: { (conversation1, conversation2) -> Bool in
            
            if conversation1.isRead == conversation2.isRead {
                
                if conversation1.conversationDate.compare(conversation2.conversationDate) == .orderedDescending
                {
                    return true
                }
                else if conversation1.conversationDate.compare(conversation2.conversationDate) == .orderedAscending
                {
                    return false
                }
                else
                {
                    return false
                }
            }
            else  {
                return conversation1.isRead
            }
        })
        //************************************************************************************************//
        //------------------------------------------------------------------------------------------------//
        //************************************************************************************************//
        
        self.targetedTableView.reloadData()
        
        if selectedConversation != nil {
            
            let index = conversations.index(of: selectedConversation)
            let indexPath = IndexPath(row:index!, section: 0)
   
            targetedTableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableViewScrollPosition.middle)

        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier:"InboxTableViewCell",for:indexPath) as! InboxTableViewCell
        
        let conversation:Conversation = conversations [indexPath.row] 
        
        cell.selectionStyle = .blue;
        
        if conversation.lastMessage != nil
        {
            cell.titleLabel.text = conversation.mobile
            cell.detailLabel.text = conversation.lastMessage
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy hh:mm:ss a"
            cell.dateLabel.text =  formatter.string(from: conversation.conversationDate)
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
        selectedConversation = conversations [indexPath.row]
        _ = self.delegate.conversationSelected(conversation: selectedConversation)
    }
}
