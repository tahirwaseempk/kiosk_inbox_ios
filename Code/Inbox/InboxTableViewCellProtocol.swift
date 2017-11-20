//
//  ConversationListingTableCellProtocol.swift
//  Inbox
//
//  Created by Amir Akram on 21/06/2017.
//  Copyright © 2017 Amir Akram. All rights reserved.
//

import UIKit

protocol ConversationListingTableCellProtocol {
   
    func conversationSelected(conversation:Conversation) -> Bool
    
}
