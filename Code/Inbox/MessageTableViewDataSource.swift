//
//  MessageTableViewDataSource.swift
//  Inbox
//
//  Created by Amir Akram on 21/06/2017.
//  Copyright © 2017 Amir Akram. All rights reserved.
//

import Foundation
import UIKit

class MessageTableViewDataSource:NSObject,UITableViewDelegate,UITableViewDataSource {
    
    let targetedTableView: UITableView
    var selectedConversation:Conversation? = nil
    var chatCell:ChatTableViewCell!
    var messages:Array<Message> = Array<Message>()
    var timeStampedMessagesDictionary = Dictionary<Date,Array<Message>>()
    var timeStampedMessagesList = Array<Date>()

    
    
    init(tableview:UITableView) {
        
        self.targetedTableView = tableview
        
        self.targetedTableView.register(ChatTableViewCell.self, forCellReuseIdentifier: "chatSend")
        self.targetedTableView.register(ChatTableViewCell.self, forCellReuseIdentifier: "chatReceive")
        
        super.init()
        
        self.targetedTableView.dataSource = self
        self.targetedTableView.delegate = self
        
        self.reloadControls()
    }
    
    func reloadControls() {
        
        if self.selectedConversation != nil{
            
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            let numberOfRows = 0 //self.targetedTableView.numberOfRows(inSection: numberOfSections)
            let numberOfSections = self.targetedTableView.numberOfSections

            if numberOfSections > 0 {
                let indexPath = IndexPath(row: numberOfRows, section: numberOfSections-1)
                self.targetedTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
                
//                self.targetedTableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableViewScrollPosition.bottom)
            }
        }
    }
    
    
    private func formattedDateFromDate(_ date:Date) -> Date
    {
        let dateFormatter =  DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = DISPLAY_FORMATE_DATE_ONLY
        
        let strDate = dateFormatter.string(from: date)
        dateFormatter.dateFormat = DISPLAY_FORMATE_DATE_ONLY

        return dateFormatter.date(from: strDate)!
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
        for message in self.messages
        {
            let date = self.formattedDateFromDate(message.msgTimeStamp)
            
            if var list = timeStampedMessagesDictionary[date]
            {
                list.append(message)
            }
            else
            {
                var newList = Array<Message>()
                
                newList.append(message)

                timeStampedMessagesDictionary[date] = newList
            }
        }
        
        timeStampedMessagesList = Array(timeStampedMessagesDictionary.keys)
       
//      timeStampedMessagesList = timeStampedMessagesList.sorted(by: <)
        
        
        
        timeStampedMessagesList = timeStampedMessagesList.sorted(by: { (key1, key2) -> Bool in
            
            if key1.compare(key2) == .orderedAscending
            {
                return true
            }
            else if key1.compare(key2) == .orderedDescending
            {
                return false
            }
            else
            {
                return false
            }
        })
        
    }
    
    
    func loadConversation(conversation_: Conversation?) -> Bool {
        self.selectedConversation = conversation_;
        self.reloadControls()
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
        
        let key = self.timeStampedMessagesList[indexPath.section]
        
        var message:Message? = nil

        if let list = self.timeStampedMessagesDictionary[key]
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
        header.textLabel?.text = self.stringFromDate(timeStampedMessagesList[section])
        header.textLabel?.textAlignment = .center
    }
    
}
