//
//  LoginViewController.swift
//  RBChatApp
//
//  Created by Rajan Balana on 27/05/20.
//  Copyright © 2020 Rajan Balana. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var usernameTextField: UITextField! {
        didSet {
            usernameTextField.delegate = self
            usernameTextField.autocorrectionType = .no
        }
    }
    
    // MARK: - Private Variables
    
    private var chatService: ChatService
    
    private var storage: Datastore
    
    // MARK: - Initalizer Implementation
    
    init(storage: Datastore, chatService: ChatService) {
        self.storage = storage
        self.chatService = chatService
        
        super.init(nibName: "LoginViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("initWithCoder is not implemented")
    }
    
    // MARK: - ViewLifeCycle Methods Implementation
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - IBActions

    @IBAction func enterButtonTapped(_ sender: UIButton) {
        
        guard let username = usernameTextField.text else {
            let alertController = UIAlertController(title: "Error", message: "Username cannot be empty", preferredStyle: .alert)
            present(alertController, animated: true, completion: nil)
            return
        }
        
        chatService.createUser(username: username) { [weak self] (user, error) in
            
            guard let strongSelf = self else {
                return
            }
            
            if let user = user {
                
                strongSelf.storage.saveLoggedInUserId(user.userId)
             
                // Go to user list
                let userListViewController = UserListViewController(storage: strongSelf.storage, chatService: strongSelf.chatService)
                strongSelf.navigationController?.pushViewController(userListViewController, animated: true)
            }
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

