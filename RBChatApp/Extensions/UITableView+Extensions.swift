//
//  UITableView+Extensions.swift
//  RBChatApp
//
//  Created by Rajan Balana on 27/05/20.
//  Copyright © 2020 Rajan Balana. All rights reserved.
//

import UIKit

extension UITableView {
    
    func scrollToBottom() {
        let scrollPoint = CGPoint(x: 0, y: self.contentSize.height - self.frame.size.height)
        self.setContentOffset(scrollPoint, animated: true)
    }
}
