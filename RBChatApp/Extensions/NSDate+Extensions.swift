//
//  NSDate+Extensions.swift
//  RBChatApp
//
//  Created by Rajan Balana on 27/05/20.
//  Copyright © 2020 Rajan Balana. All rights reserved.
//

import Foundation

extension NSDate {

    func getCurrentTimeStamp() -> String {
            return "\(Double(self.timeIntervalSince1970 * 1000))"
    }
}
