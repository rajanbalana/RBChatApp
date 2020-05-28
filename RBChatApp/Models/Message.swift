//
//  Message.swift
//  RBChatApp
//
//  Created by Rajan Balana on 27/05/20.
//  Copyright © 2020 Rajan Balana. All rights reserved.
//

import Foundation

struct Message {
    let text: String
    let senderId: String
    let receiverId: String
    var isSentByMe: Bool
}

extension Message: DatabaseRepresentation {
    
    var databaseRepresentation: [String : Any] {
     
        var dict = [String: Any]()
        dict["text"] = text
        dict["senderId"] = senderId
        dict["receiverId"] = receiverId
        return dict
    }
}

extension Message: KeyGenerator {
    
    func key() -> String {
        return "\(String(describing: NSDate().getCurrentTimeStamp().replacingOccurrences(of: ".", with: "")))" + "_" + "\(senderId)" + "_" + "\(receiverId)"
    }
}


