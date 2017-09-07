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
    var filteredConversations:Array<Conversation> = Array<Conversation>()
    var selectedConversation:Conversation! = nil
    var delegate:InboxTableViewCellProtocol
    
    init(tableview:UITableView, conversation: NSSet, delegate_:InboxTableViewCellProtocol) {
        
        self.targetedTableView = tableview
        
        self.delegate = delegate_
        
        super.init()
        
        self.targetedTableView.dataSource = self
        self.targetedTableView.delegate = self
        self.targetedTableView.register(UINib(nibName:"InboxTableViewCell",bundle:nil),forCellReuseIdentifier:"InboxTableViewCell")
        
        self.applySearchFiltersForSearchText("")
        //self.reloadControls()
    }
    
    func reloadControls() {
        
        //************************************************************************************************//
        //------------------------------------------------------------------------------------------------//
        //************************************************************************************************//
        filteredConversations = filteredConversations.sorted(by: { (conversation1, conversation2) -> Bool in

            //print(conversation1.isRead, conversation2.isRead)
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
            
            let index = filteredConversations.index(of: selectedConversation)
            let indexPath = IndexPath(row:index!, section: 0)
   
            targetedTableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableViewScrollPosition.middle)
        }
        else {
          
            let indexPath = IndexPath(row:-1, section: 0)
            targetedTableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableViewScrollPosition.none)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return filteredConversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier:"InboxTableViewCell",for:indexPath) as! InboxTableViewCell
        
        let conversation:Conversation = filteredConversations [indexPath.row]
        
        cell.selectionStyle = .blue;
        
        if conversation.lastMessage != nil
        {
            cell.titleLabel.text = conversation.mobile
            cell.detailLabel.text = conversation.lastMessage
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/YYYY hh:mm:ss a"
            cell.dateLabel.text = "Sent" + " " + dateFormatter.string(from: conversation.conversationDate)
        }
        else
        {
            cell.titleLabel.text = conversation.mobileNumber
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
        selectedConversation = filteredConversations [indexPath.row]
        _ = self.delegate.conversationSelected(conversation: selectedConversation)
    }
}

extension InboxTableViewDataSource {
    
    func applySearchFiltersForSearchText(_ text:String)
    {
        conversations = (User.getLoginedUser()?.conversations?.allObjects as? Array<Conversation>)!
        
        if text.characters.count > 0
        {
            filteredConversations = conversations.filter({ (conversation1) -> Bool in
                
                if ((conversation1.mobile?.contains(text))! || (conversation1.lastMessage?.contains(text))!)
                {
                    selectedConversation = nil
                    return true
                }
                else
                {
                    return false
                }
            })
        }
        else
        {
            selectedConversation = nil
            filteredConversations = conversations
        }
        
        self.reloadControls()
    }

}
