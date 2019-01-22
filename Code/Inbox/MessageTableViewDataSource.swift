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
        guard (self.selectedConversation == nil) else {
            return (self.selectedConversation!.messages!.count)
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell : ChatTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell", for: indexPath) as! ChatTableViewCell
        
        let message:Message = messages[indexPath.section]

        //-----------------------------------------------------------//
        //-----------------------------------------------------------//
        let dateFormatter =  DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = DISPLAY_FORMATE_STRING
        let outStr = dateFormatter.string(from: message.msgTimeStamp)
        //-----------------------------------------------------------//
        //-----------------------------------------------------------//
        
        if (message.isSender == false) {
            cell.loadCellData(text: message.messageText!, type: .ChatCellAuthorTypeReceiver, number: (self.selectedConversation?.receiver?.phoneNumber)!, dateTime: outStr)

        } else {
            
            cell.loadCellData(text: message.messageText!, type: .ChatCellAuthorTypeSender, number: "Me", dateTime: outStr)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = UIColor.clear
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.clear
    }
    
    
    
    func serverToLocal(date:String) -> String {
      
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
     
        let localDate = dateFormatter.date(from: date)
        dateFormatter.dateFormat = DISPLAY_FORMATE_STRING
       
        let outStr = dateFormatter.string(from: localDate!)

        
        return outStr
    }
    
}
