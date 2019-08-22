import Foundation

protocol ConversationListingViewControllerProtocol
{
    func conversationSelected(conversation:Conversation?) -> Bool
    
    func updateConversationCount(str:String) -> Bool
    
    
}


