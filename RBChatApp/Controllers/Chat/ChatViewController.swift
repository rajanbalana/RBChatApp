//
//  ChatViewController.swift
//  RBChatApp
//
//  Created by Rajan Balana on 27/05/20.
//  Copyright © 2020 Rajan Balana. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ChatViewController: UIViewController {

    
    // MARK: - Private Variables
    
    private var tableView: UITableView = {
       var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .interactive
        return tableView
    }()
    
    private var bottomMessageBoxView: UIView = {
       let boxView = UIView()
        boxView.translatesAutoresizingMaskIntoConstraints = false
        boxView.backgroundColor = .white
        boxView.layer.borderColor = UIColor.lightGray.cgColor
        boxView.layer.borderWidth = 0.5
        return boxView
    }()
    
    private var messageTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("Send", comment: ""), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var bottomMessageBoxBottomConstraint: NSLayoutConstraint?
    
    private var loggedInUserId: String {
        return self.dataStore.getLoggedInUserId()!
    }
    
    private let cellIdentifier = "messageCellIdentifier"
    
    private var databaseRef: DatabaseReference = Database.database().reference()
    
    private var messages = [Message]()
    
    private let user: User
    
    private let dataStore: Datastore
    
    private let chatService: ChatService
    
    // MARK: - Init Methods Implementation
    
    init(user: User, dataStore: Datastore, chatService: ChatService) {
        self.user = user
        self.dataStore = dataStore
        self.chatService = chatService
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("initWithCoder not implemented")
    }
    
    // MARK: - ViewLifeCycle Methods Implementation
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = user.username
        
        addSubviews()
        setupTableView()
        setupBottomView()
        
        fetchMessages()
        
        addKeyboardNotificationObservers()
    }
    
    // MARK: - Private Methods Implementation
    
    private func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(bottomMessageBoxView)
        bottomMessageBoxView.addSubview(messageTextField)
        bottomMessageBoxView.addSubview(sendButton)
    }
    
    private func setupTableView() {
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomMessageBoxView.topAnchor, constant: 0.0).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0).isActive = true
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupBottomView() {
        
        let layoutGuide = view.safeAreaLayoutGuide

        bottomMessageBoxBottomConstraint = bottomMessageBoxView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: 0.0)
        bottomMessageBoxBottomConstraint?.isActive = true
        bottomMessageBoxView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        bottomMessageBoxView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        bottomMessageBoxView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        messageTextField.leadingAnchor.constraint(equalTo: bottomMessageBoxView.leadingAnchor, constant: 10).isActive = true
        messageTextField.topAnchor.constraint(equalTo: bottomMessageBoxView.topAnchor, constant: 10).isActive = true
        messageTextField.bottomAnchor.constraint(equalTo: bottomMessageBoxView.bottomAnchor, constant: -10).isActive = true
        
        bottomMessageBoxView.layoutIfNeeded()
        
        sendButton.leadingAnchor.constraint(equalTo: messageTextField.trailingAnchor, constant: 0.0).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: bottomMessageBoxView.bounds.size.width * 0.20).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: bottomMessageBoxView.bottomAnchor, constant: 0.0).isActive = true
        sendButton.trailingAnchor.constraint(equalTo: bottomMessageBoxView.trailingAnchor, constant: 0.0).isActive = true
        sendButton.topAnchor.constraint(equalTo: bottomMessageBoxView.topAnchor, constant: 0.0).isActive = true   
    }
    
    private func fetchMessages() {
        
        chatService.fetchConversation(userId: user.userId) { [weak self] (message, error) in
            
            guard let strongSelf = self else {
                return
            }
            
            if let message = message {
                strongSelf.messages.append(message)
                strongSelf.animateMessageInsertion()
            }
        }        
    }
    
    private func clearMessageTextField() {
        messageTextField.text = ""
    }
    
    private func addKeyboardNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func animateMessageInsertion() {
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    // MARK: - IBActions Methods Implementation
    
    @objc private func sendButtonTapped(_ button: UIButton) {
        
        guard let text = messageTextField.text else {
            let alertController = UIAlertController(title: "Error", message: "Message cannot be empty", preferredStyle: .alert)
            present(alertController, animated: true, completion: nil)
            return
        }
        
        let message = Message(text: text, senderId: loggedInUserId, receiverId: user.userId, isSentByMe: true)
        chatService.sendMessage(message: message)
        clearMessageTextField()
    }
    
    // MARK: - UIKeyboardNotification Methods Implementation
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            bottomMessageBoxBottomConstraint?.constant = (keyboardSize.height) * -1.0
            self.view.layoutIfNeeded()
        }
        
        tableView.scrollToBottom()
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            bottomMessageBoxBottomConstraint?.constant = 0.0
            self.view.layoutIfNeeded()
        }
        
        tableView.scrollToBottom()
    }
}

// MARK: - UITableViewDataSource Methods Implementation

extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? MessageTableViewCell
        
        if cell == nil {
            cell = MessageTableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        
        let message = messages[indexPath.row]
        cell!.configure(message: message.text, isCurrentUser: message.isSentByMe)
        return cell!
    }
}

// MARK: - UITableViewDelegate Methods Implementation

extension ChatViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
