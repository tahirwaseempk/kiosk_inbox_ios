//
//  MessageTableViewDataSource.swift
//  Inbox
//
//  Created by Amir Akram on 21/06/2017.
//  Copyright © 2017 Amir Akram. All rights reserved.
//

import Foundation
import UIKit

protocol MessageTableViewDataSourceProtocol
{
    func loadMoreMessages(messageId:String, completionBlockSuccess successBlock: @escaping ((_ messages:Array<Message>) -> (Void)), andFailureBlock failureBlock: @escaping ((Error?) -> (Void)))
}


class MessageTableViewDataSource:NSObject,UITableViewDelegate,UITableViewDataSource, UIScrollViewDelegate
{
    let targetedTableView: UITableView
    let delegate: ConversationDetailViewController?
    var selectedConversation:Conversation? = nil
    var chatCell:ChatTableViewCell!
    var messages:Array<Message> = Array<Message>()
    var timeStampedMessagesDictionary = Dictionary<String,Array<Message>>()
    var timeStampedMessagesList = Array<String>()
    var isCallAlreadySent = false
    var isFirstTime = true
    
    init(tableview:UITableView, delegate_: ConversationDetailViewController)
    {
        self.targetedTableView = tableview
        
        self.targetedTableView.register(ChatTableViewCell.self, forCellReuseIdentifier: "chatSend")
        
        self.targetedTableView.register(ChatTableViewCell.self, forCellReuseIdentifier: "chatReceive")
        
        self.delegate = delegate_
        
        super.init()
        
        self.targetedTableView.dataSource = self
        
        self.targetedTableView.delegate = self
        
        
        self.reloadControls(shouldScroll: true)
    }
    
    func reloadControls(shouldScroll:Bool)
    {
        if self.selectedConversation != nil
        {
            messages = selectedConversation?.messages?.allObjects as! Array<Message>
            
            messages = messages.sorted(by: { (mesage1, message2) -> Bool in
                
                if mesage1.msgTimeStamp.compare(message2.msgTimeStamp) == .orderedAscending
                {
                    return true
                }
                else if mesage1.msgTimeStamp.compare(message2.msgTimeStamp) == .orderedDescending
                {
                    return false
                }
                else
                {
                    return false
                }
            })
        }
        else
        {
            messages.removeAll()
        }
        
        self.filterMessages()
        
        self.targetedTableView.reloadData()
        
        
        if shouldScroll == true {
            
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300))
        {
            let numberOfSections = self.targetedTableView.numberOfSections
            
            var numberOfRows = 0
            
            if numberOfSections > 0
            {
                let key = self.timeStampedMessagesList[numberOfSections-1]
                
                if let list = self.timeStampedMessagesDictionary[key]
                {
                    numberOfRows =  list.count
                }
                
                if numberOfSections > 0
                {
                    let indexPath = IndexPath(row: numberOfRows-1, section: numberOfSections-1)
                    
                    self.targetedTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
                }
            }
        }
        }
    }
    
    private func formattedDateFromDate(_ date:Date) -> String
    {
        let dateFormatter =  DateFormatter()
        //dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = DISPLAY_FORMATE_DATE_ONLY
        
        //let strDate = dateFormatter.string(from: date)
        //dateFormatter.dateFormat = DISPLAY_FORMATE_DATE_ONLY
        
        return dateFormatter.string(from: date) //dateFormatter.date(from: strDate)!
    }
    
    
    
    private func formattedDateFromString(_ str:String) -> Date
    {
        let dateFormatter =  DateFormatter()
        //dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = DISPLAY_FORMATE_DATE_ONLY
        return dateFormatter.date(from: str) ?? Date()
        
    }
    
    
    private func stringFromDate(_ date:Date) -> String
    {
        let dateFormatter =  DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = DISPLAY_FORMATE_DATE_ONLY
        
        return dateFormatter.string(from: date)
    }
    
    private func filterMessages()
    {
        timeStampedMessagesDictionary.removeAll()
        timeStampedMessagesList.removeAll()
        
        for message in self.messages
        {
            let date = self.formattedDateFromDate(message.msgTimeStamp)
            
            if var list = timeStampedMessagesDictionary[date]
            {
                list.append(message)
                timeStampedMessagesDictionary[date] = list
                
            }
            else
            {
                var newList = Array<Message>()
                newList.append(message)
                timeStampedMessagesDictionary[date] = newList
            }
        }
        
        timeStampedMessagesList = Array(timeStampedMessagesDictionary.keys)
        
        timeStampedMessagesList = timeStampedMessagesList.sorted(by: { (key1, key2) -> Bool in
            
            let date1 = self.formattedDateFromString(key1)
            let date2 = self.formattedDateFromString(key2)
            
            if date1.compare(date2) == .orderedAscending
            {
                return true
            }
            else if date1.compare(date2) == .orderedDescending
            {
                return false
            }
            else
            {
                return false
            }
        })
        
    }
    
    
    func loadConversation(conversation_: Conversation?, shouldTableViewScroll: Bool) -> Bool {
        self.selectedConversation = conversation_;
        self.reloadControls(shouldScroll: shouldTableViewScroll)
        return true
    }
    //************************************************************************************************//
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //------------------------------------------------------------------------------------------------//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    //************************************************************************************************//
    
    //MARK: -  TableView Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return self.timeStampedMessagesList.count
        
        //        guard (self.selectedConversation == nil) else {
        //
        //            return (self.selectedConversation!.messages!.count)
        //        }
        //        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let key = self.timeStampedMessagesList[section]
        
        if let list = self.timeStampedMessagesDictionary[key]
        {
            return list.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell : ChatTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell", for: indexPath) as! ChatTableViewCell
        
        let key = timeStampedMessagesList[indexPath.section]
        var message:Message? = nil
        
        if let list = timeStampedMessagesDictionary[key]
        {
            message = list[indexPath.row]
        }
        
        if let message = message
        {
            //-----------------------------------------------------------//
            //-----------------------------------------------------------//
            let dateFormatter =  DateFormatter()
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = DISPLAY_FORMATE_TIME_ONLY
            let outStr = dateFormatter.string(from: message.msgTimeStamp)
            //-----------------------------------------------------------//
            //-----------------------------------------------------------//
            
            if (message.isSender == false) {
                cell.loadCellData(text: message.messageText!, type: .ChatCellAuthorTypeReceiver, number: (self.selectedConversation?.receiver?.phoneNumber)!, dateTime: outStr)
                
            } else {
                
                cell.loadCellData(text: message.messageText!, type: .ChatCellAuthorTypeSender, number: "Me", dateTime: outStr)
            }
            
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 22.0
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = UIColor.clear
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.black
        header.textLabel?.font = UIFont.systemFont(ofSize: 8.0)
        header.textLabel?.text = timeStampedMessagesList[section] //self.stringFromDate(timeStampedMessagesList[section])
        header.textLabel?.textAlignment = .center
    }
    
    //************************************************************************************************//
    //************************************************************************************************//
    //------------------------------------------------------------------------------------------------//
    //------------------------------------------------------------------------------------------------//
    //------------------------------------------------------------------------------------------------//
    //************************************************************************************************//
    //************************************************************************************************//
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        //        let firstSection = 0
        //        let lastMessageDate = timeStampedMessagesList[firstSection]
        //        let lastDateMessagesArray = timeStampedMessagesDictionary[lastMessageDate]
        //        let totalNumberOfRows = (lastDateMessagesArray!.count - 1)
        //
        //        if indexPath.section == firstSection && indexPath.row == totalNumberOfRows
        //        {
        //            if let message = lastDateMessagesArray?.last
        //            {
        //                //self.loadMoreData(messageId:String(message.messageId))
        //            }
        //
        //        }
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        
        if scrollView.contentOffset.y == 0 //distanceFromBottom < height
        {
            self.loadMoreData()
        }
    }
    
    func loadMoreData()
    {
        if isCallAlreadySent == false, let delegate = self.delegate
        {
            let firstSection = 0
            
            let lastMessageDate = timeStampedMessagesList[firstSection]
            
            let lastDateMessagesArray = timeStampedMessagesDictionary[lastMessageDate]
            
            if let message = lastDateMessagesArray?.last
            {
                isCallAlreadySent = true
                
                delegate.loadMoreMessages(messageId:String(message.messageId), completionBlockSuccess: { (newMessages:Array<Message>) -> (Void) in
                    
                    // New Messages Recvd From Server
                    self.isCallAlreadySent = false
                    
                }, andFailureBlock: { (error:Error?) -> (Void) in
                    
                    // Failed To Rcv New Messages From Server
                    self.isCallAlreadySent = false
                })
            }
        }
    }
}
