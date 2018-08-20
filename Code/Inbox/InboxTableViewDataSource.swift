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
    var delegate:ConversationListingTableCellProtocol
    var searchView:SearchView!
    
    init(tableview:UITableView, conversation: NSSet, delegate_:ConversationListingTableCellProtocol) {
        
        
        self.targetedTableView = tableview
        
        self.delegate = delegate_
        
        super.init()
        
        self.targetedTableView.dataSource = self
        self.targetedTableView.delegate = self
        self.targetedTableView.register(UINib(nibName:"InboxTableViewCell",bundle:nil),forCellReuseIdentifier:"InboxTableViewCell")
        
        self.targetedTableView.register(UINib(nibName: "SearchView", bundle: nil), forHeaderFooterViewReuseIdentifier: "SearchView")

        self.applySearchFiltersForSearchText("")
        //self.reloadControls()
    }
    
    func reloadControls() {
        
        //************************************************************************************************//
        //------------------------------------------------------------------------------------------------//
        //************************************************************************************************//
        filteredConversations = filteredConversations.sorted(by: { (conversation1, conversation2) -> Bool in

            //print(conversation1.isRead, conversation2.isRead)
//            if conversation1.isRead == conversation2.isRead {
                        
                if conversation1.timeStamp.compare(conversation2.timeStamp) == .orderedDescending
                {
                    return true
                }
                else if conversation1.timeStamp.compare(conversation2.timeStamp) == .orderedAscending
                {
                    return false
                }
                else
                {
                    return false
                }
//            }
//            else  {
//                return conversation1.isRead
//            }
        })
        //************************************************************************************************//
        //------------------------------------------------------------------------------------------------//
        //************************************************************************************************//
        
        self.targetedTableView.reloadData()
        
        if selectedConversation != nil {
            
            let index = filteredConversations.index(of: selectedConversation)
            let indexPath = IndexPath(row:index!, section: 0)
   
            targetedTableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableViewScrollPosition.none)
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            return 50.0;
        }
        
        return 1.0;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            self.searchView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SearchView" ) as! SearchView
            
            self.searchView.delegate = self
            
            return self.searchView
        }
        
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier:"InboxTableViewCell",for:indexPath) as! InboxTableViewCell
        
        let conversation:Conversation = filteredConversations [indexPath.row]
        
        cell.selectionStyle = .default
        
        if conversation.lastMessage != nil
        {
           
            if conversation.receiver?.firstName?.isEmpty == false &&
                conversation.receiver?.lastName?.isEmpty == false
            {
                cell.titleLabel.text = ((conversation.receiver?.firstName)! + " " + (conversation.receiver?.lastName)!)
            }
            else {
                cell.titleLabel.text = conversation.receiver?.phoneNumber
            }
            
            
            
            cell.detailLabel.text = conversation.lastMessage
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = DISPLAY_FORMATE_STRING
            cell.dateLabel.text = "Sent" + " " + dateFormatter.string(from: conversation.timeStamp)
        }
        else
        {
            cell.titleLabel.text = "MOBILE NUMBER" //conversation.mobileNumber
            cell.detailLabel.text = "no message"
            cell.dateLabel.text = ""
        }
        
        if conversation.unreadMessages == true
        {
            cell.dotImageView.image = UIImage(named: "blackdot.png")
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

extension InboxTableViewDataSource:SearchViewProtocol
{    
    func applySearchFiltersForSearchText(_ text:String)
    {
        conversations = (User.getLoginedUser()?.conversations?.allObjects as? Array<Conversation>)!
        
        if text.count > 0
        {
            filteredConversations = conversations.filter({ (conversation1) -> Bool in
                
                if ((conversation1.sender?.phoneNumber?.contains(text))! ||
                    (conversation1.receiver?.phoneNumber?.contains(text))! ||
                    (conversation1.lastMessage?.contains(text))!)
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
    
    func loadAfterRemoveConversation () {
        
        self.applySearchFiltersForSearchText("")
        self.selectedConversation = nil
        self.reloadControls()
        
    }

}
