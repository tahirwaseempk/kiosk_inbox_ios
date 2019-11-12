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
        
        // self.targetedTableView.register(UINib(nibName: "SearchView", bundle: nil), forHeaderFooterViewReuseIdentifier: "SearchView")
        
        self.applySearchFiltersForSearchText("")
        //self.reloadControls()
    }
    
    func reloadControls()
    {
        filteredConversations = filteredConversations.sorted(by: { (conversation1, conversation2) -> Bool in
                    
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
     })

        self.targetedTableView.reloadData()
        
        if selectedConversation != nil
        {
            let index = filteredConversations.index(of: selectedConversation)
            
            let indexPath = IndexPath(row:index!, section: 0)
            
            targetedTableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableViewScrollPosition.none)
        }
        else
        {
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
        //        if UIDevice.current.userInterfaceIdiom == .pad
        //        {
        //            return 50.0;
        //        }
        
        return 1.0;
    }
    
    //    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    //    {
    //        if UIDevice.current.userInterfaceIdiom == .pad
    //        {
    //            self.searchView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SearchView" ) as? SearchView
    //
    //            self.searchView.delegate = self
    //
    //            return self.searchView
    //        }
    //
    //        return UIView()
    //    }
    
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
            
            //-----------------------------------------------------------//
            //-----------------------------------------------------------//
            //            let dateFormatter =  DateFormatter()
            //            dateFormatter.timeZone = TimeZone.current
            //            dateFormatter.dateFormat = DISPLAY_FORMATE_STRING
            //            let outStr = dateFormatter.string(from: conversation.timeStamp)
            let outStr = self.relativePast(for: conversation.timeStamp)
            //-----------------------------------------------------------//
            //-----------------------------------------------------------//
            
            cell.dateLabel.text = outStr
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
    
    func relativePast(for date : Date) -> String {
        
        let units = Set<Calendar.Component>([.year, .month, .day, .hour, .minute, .second, .weekOfYear])
        let components = Calendar.current.dateComponents(units, from: date, to: Date())
        
        if components.year! > 0 {
            return "\(components.year!) " + (components.year! > 1 ? "years ago" : "year ago")
            
        } else if components.month! > 0 {
            return "\(components.month!) " + (components.month! > 1 ? "months ago" : "month ago")
            
        } else if components.weekOfYear! > 0 {
            
            //            if (components.weekOfYear! == 1) {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone.current
            //                dateFormatter.dateFormat = "dd-MM-yyyy"
            dateFormatter.dateFormat = "EEEE"
            return dateFormatter.string(from: date)
            
            //            } else {
            //            return "\(components.weekOfYear!) " + (components.weekOfYear! > 1 ? "weeks ago" : "week ago")
            //
            //            }
            
        } else if (components.day! > 0) {
            return (components.day! > 1 ? "\(components.day!) days ago" : "Yesterday")
            
        } else if components.hour! > 0 {
            return "\(components.hour!) " + (components.hour! > 1 ? "hours ago" : "hour ago")
            
        } else if components.minute! > 0 {
            return "\(components.minute!) " + (components.minute! > 1 ? "minutes ago" : "minute ago")
            
        } else {
            return "\(components.second!) " + (components.second! > 1 ? "seconds ago" : "second ago")
        }
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
                
                //                if ((conversation1.sender?.phoneNumber?.containsText(text))! ||
                //                    (conversation1.receiver?.phoneNumber?.containsText(text))! ||
                //                    (conversation1.lastMessage?.containsText(text))! ||
                //                    (conversation1.receiver?.firstName?.containsText(text))! ||
                //                    (conversation1.receiver?.lastName?.containsText(text))!)
                //                {
                //                    selectedConversation = nil
                //                    return true
                //                }
                //                else{
                //                    return false
                //                }
                //                print("Sender" + conversation1.sender!.phoneNumber!)
                //                print("Receiver" + conversation1.receiver!.phoneNumber!)
                
                if let receiver = conversation1.receiver
                {
                    if let phoneNumber:String = removeSpecialCharsFromString(receiver.phoneNumber!)
                    {
                        if phoneNumber.containsText(text){
                            selectedConversation = nil
                            return true
                        }
                    }
                    
                    if let firstName = receiver.firstName
                    {
                        if firstName.containsText(text){
                            selectedConversation = nil
                            return true
                        }
                    }
                    
                    if let lastName = receiver.lastName
                    {
                        if lastName.containsText(text){
                            selectedConversation = nil
                            return true
                        }
                    }
                    
                }
                
                if let sender = conversation1.sender
                {
                    if let phoneNumber:String = removeSpecialCharsFromString(sender.phoneNumber!)
                    {
                        
                        if phoneNumber.containsText(text){
                            selectedConversation = nil
                            return true
                        }
                    }
                }
                
                if let lastMessage = conversation1.lastMessage
                {
                    if lastMessage.containsText(text){
                        selectedConversation = nil
                        return true
                    }
                }
                
                //                if ((conversation1.sender?.phoneNumber?.contains(text))! ||
                //                    (conversation1.receiver?.phoneNumber?.containsText(text))! ||
                //                    (conversation1.lastMessage?.containsText(text))! ||
                //                    (conversation1.receiver?.firstName?.containsText(text))! ||
                //                    (conversation1.receiver?.lastName?.containsText(text))!)
                //                {
                //                    selectedConversation = nil
                //                    return true
                //                }
                //                else
                //                {
                return false
                //                }
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
