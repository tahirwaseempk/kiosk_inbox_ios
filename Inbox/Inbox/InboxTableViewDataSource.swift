//
//  MessageTableViewDataSource.swift
//  Inbox
//
//  Created by tahir on 20/06/2017.
//  Copyright © 2017 Amir Akram. All rights reserved.
//

import Foundation
import UIKit

class InboxTableViewDataSource:NSObject,UITableViewDelegate,UITableViewDataSource {

    let targetedTableView: UITableView
    
    init(tableview:UITableView) {
        
        self.targetedTableView = tableview
        
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier:"InboxTableViewCell",for:indexPath) as! InboxTableViewCell
        
        cell.selectionStyle  = .none
        
        return cell
    }
    
    func tableView(_ tableView:UITableView,didSelectRowAt indexPath:IndexPath)
    {
        
    }
}
