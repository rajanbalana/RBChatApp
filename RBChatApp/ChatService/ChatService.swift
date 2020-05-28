//
//  ChatService.swift
//  RBChatApp
//
//  Created by Rajan Balana on 27/05/20.
//  Copyright © 2020 Rajan Balana. All rights reserved.
//

import Foundation

protocol ChatService {
    func createUser(username: String, completion: @escaping (User?, Error?) -> Void)
    func fetchUserList(completion: @escaping ([User]?, Error?) -> Void)
    func fetchConversation(userId: String, completion: @escaping (Message?, Error?) -> Void)
    func sendMessage(message: Message)
}
