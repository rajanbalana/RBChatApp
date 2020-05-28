//
//  UserListViewController.swift
//  RBChatApp
//
//  Created by Rajan Balana on 27/05/20.
//  Copyright © 2020 Rajan Balana. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class UserListViewController: UITableViewController {

    struct Constants {
        static let cellHeight: CGFloat = 55.0
    }
    
    // MARK: - Private Variables
    private var cellIdentifier = "userTableViewCell"

    private var databaseReference: DatabaseReference = Database.database().reference()
    
    private var users = [User]()
    
    private let storage: Datastore
    
    private let chatService: ChatService
    
    // MARK: - Intializer Methods Implementation
    
    init(storage: Datastore, chatService: ChatService) {
        self.storage = storage
        self.chatService = chatService
        super.init(nibName: nil, bundle: nil)
        
        self.tableView.tableFooterView = UIView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("initWithCoder not implemented")
    }
    
    // MARK: - ViewLifeCycle Methods Implementation
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.title = NSLocalizedString("Users", comment: "")
        
        clearsSelectionOnViewWillAppear = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        navigationItem.hidesBackButton = true
        
        fetchUsers()
    }
    
    // MARK: - Private Methods Implementation
    
    private func fetchUsers() {
        
        chatService.fetchUserList { [weak self] (users, error) in
            
            guard let strongSelf = self else {
                return
            }
            
            if let users = users {
                strongSelf.users.append(contentsOf: users)
                strongSelf.tableView.reloadData()
            }
        }
    }
}

// MARK: - UITableViewDelegate Methods Implementation

extension UserListViewController {
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return users.count
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return Constants.cellHeight
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) else {
        fatalError()
    }
    
    cell.accessoryType = .disclosureIndicator
    cell.textLabel?.text = users[indexPath.row].username
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let user = users[indexPath.row]
    let vc = ChatViewController(user: user, dataStore: storage, chatService: chatService)
    navigationController?.pushViewController(vc, animated: true)
  }
}
