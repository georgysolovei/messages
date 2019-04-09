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
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var personView: PersonView!
    
    var message: MessageDTO? {
        didSet {
            guard let message = message else { return }

            messageLabel.text = message.content
            nameLabel.text    = message.author.name
            
            let date = Date.init(dateString: message.updated, pattern: serverDatePattern)
            dateLabel.text = date.string(pattern: longLiteralPattern)
            
            personView.loadImage(message.author.photoUrl)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        maxBubbleWidth.constant = UIScreen.main.bounds.width * 0.75
        labelSuperview.layer.cornerRadius = labelSuperview.frame.width / 4
        
    }

}
