//
//  MessageTableViewCell.swift
//  RBChatApp
//
//  Created by Rajan Balana on 27/05/20.
//  Copyright © 2020 Rajan Balana. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        messageLabel.text = nil
    }
    
    private var messageBoxView: UIView = {
       let boxView = UIView()
        boxView.translatesAutoresizingMaskIntoConstraints = false
        boxView.backgroundColor = .white
        boxView.layer.borderWidth = 0.5
        return boxView
    }()
    
    private var messageLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        return messageLabel
    }()
    
    private var leadingAnchorContraint: NSLayoutConstraint?
    private var trailingAnchorContraint: NSLayoutConstraint?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(messageBoxView)
        messageBoxView.addSubview(messageLabel)
        
        
        messageBoxView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0).isActive = true
        messageBoxView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10.0).isActive = true
        trailingAnchorContraint = messageBoxView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30.0)
        leadingAnchorContraint = messageBoxView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0)
        
        
        messageLabel.topAnchor.constraint(equalTo: messageBoxView.topAnchor, constant: 5.0).isActive = true
        messageLabel.leadingAnchor.constraint(equalTo: messageBoxView.leadingAnchor, constant: 5.0).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: messageBoxView.trailingAnchor, constant: -5.0).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: messageBoxView.bottomAnchor, constant: -5.0).isActive = true
        
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("initWithCoder not implemented")
    }
    
    func configure(message: String, isCurrentUser: Bool) {
        messageLabel.text = message
   
        if isCurrentUser {
            trailingAnchorContraint?.isActive = true
            leadingAnchorContraint?.isActive = false
            messageBoxView.backgroundColor = .lightGray
        }
        else {
            trailingAnchorContraint?.isActive = false
            leadingAnchorContraint?.isActive = true
            messageBoxView.backgroundColor = .systemGreen
        }
    }
}
