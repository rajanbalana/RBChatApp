//
//  AppDelegate.swift
//  RBChatApp
//
//  Created by Rajan Balana on 27/05/20.
//  Copyright © 2020 Rajan Balana. All rights reserved.
//

import UIKit

import Firebase
import FirebaseDatabase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigationController: UINavigationController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.tintColor = .systemBlue
        self.window!.backgroundColor = .white
        
        let storage = LocalDataStorage()
        let chatService = FirebaseChatService.shared
        
        var rootViewController: UIViewController = LoginViewController(storage: storage, chatService: chatService)
        
        if storage.getLoggedInUserId() != nil {
            rootViewController = UserListViewController(storage: storage, chatService: chatService)
        }
        
        navigationController = UINavigationController(rootViewController: rootViewController)
        self.window!.rootViewController = navigationController
        self.window!.makeKeyAndVisible()
        
        return true
    }
}

