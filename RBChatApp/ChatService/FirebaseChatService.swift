//
//  FirebaseChatService.swift
//  RBChatApp
//
//  Created by Rajan Balana on 27/05/20.
//  Copyright © 2020 Rajan Balana. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase

enum ChatServiceError: Error {
    case userNotLoggedIn
    case serviceError(String)
}

class FirebaseChatService: ChatService {
    
    struct Constants {
        static let usersKey = "users"
        static let chatKey = "chat"
        static let username = "username"
    }
    
    static let shared: FirebaseChatService = FirebaseChatService()
    
    private var storage: Datastore
    
    private var databaseRef: DatabaseReference
    
    private init() {
        
        FirebaseApp.configure()
        
        self.databaseRef = Database.database().reference()
        self.storage = LocalDataStorage()
        
    }
    
    func createUser(username: String, completion: @escaping (User?, Error?) -> Void) {
        
        let ref = databaseRef.child(Constants.usersKey).childByAutoId()
        let userId = ref.key
        
        ref.setValue([Constants.username : username]) { (error, ref) in
            
            if let userId = userId {
                completion(User(userId: userId, username: username), error)
            }
            else {
                completion(nil, error)
            }
        }
    }
    
    func fetchUserList(completion: @escaping ([User]?, Error?) -> Void) {
        
        databaseRef.child(Constants.usersKey).observeSingleEvent(of: .value) { (snapshot) in
            
            var users: [User]?
            
            if snapshot.exists() {
                
                if let snapshotObjects = snapshot.value as? Dictionary<String, AnyObject> {
                    
                    users  = [User]()
                    
                    for (userId, userInfo) in snapshotObjects where userId != self.storage.getLoggedInUserId() {
                        
                        let userName = userInfo[Constants.username] as? String
                        let user = User(userId: userId, username: userName ?? "")
                        users?.append(user)
                    }
                }
            }
            completion(users, nil)
        }
    }
    
    func fetchConversation(userId: String, completion: @escaping (Message?, Error?) -> Void) {
       
        guard let loggedInUserId = storage.getLoggedInUserId() else {
            completion(nil, ChatServiceError.userNotLoggedIn)
            return
        }
        
        databaseRef.child(Constants.chatKey).child(loggedInUserId).child(userId).observe(.childAdded) { (snapshot) in
            
            if snapshot.exists() {
                
                let components = snapshot.key.components(separatedBy: "_")
                let senderId = components[1]
                let receivedId = components[2]
                let isSentByMe = senderId == loggedInUserId
                let message = Message(text: snapshot.value as! String, senderId: senderId, receiverId: receivedId, isSentByMe: isSentByMe)
                completion(message, nil)
            }
            else {
                completion(nil, ChatServiceError.serviceError("Unknown error occurred"))
            }
        }
    }
    
    func sendMessage(message: Message) {
        databaseRef.child(Constants.chatKey).child(message.senderId).child(message.receiverId).updateChildValues([message.key(): message.text])
        databaseRef.child(Constants.chatKey).child(message.receiverId).child(message.senderId).updateChildValues([message.key(): message.text])
    }
}
