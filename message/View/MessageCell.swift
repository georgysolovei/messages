//
//  MessageCell.swift
//  message
//
//  Created by mac-167-71 on 4/9/19.
//  Copyright © 2019 home. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var labelSuperview: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var maxBubbleWidth: NSLayoutConstraint!
    @IBOutlet weak var dateLabel: UILabel!
    
    var message: Message? {
        didSet {
            guard let message = message else { return }

            messageLabel.text = message.content
            dateLabel.text    = message.updated

        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        maxBubbleWidth.constant = UIScreen.main.bounds.width * 0.8
        labelSuperview.layer.cornerRadius = labelSuperview.frame.width / 4
    }

}
