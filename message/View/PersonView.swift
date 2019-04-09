//
//  PersonView.swift
//  message
//
//  Created by mac-167-71 on 4/9/19.
//  Copyright © 2019 home. All rights reserved.
//

import UIKit
import RealmSwift
import Kingfisher

class PersonView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var placeholderImageView: UIImageView!
    @IBOutlet weak var personImageView: UIImageView!
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // MARK: - Methods
    
    func setPlaceholder() {
        personImageView.image = nil
    }
    
    func loadImage(_ URLString: String?) {//, personView: PersonView, dateString: String? = nil, isForcedCacheClean: Bool = false) {
        guard let urlString = URLString else {
            personImageView.image = nil
            return
        }
        
        let url = URL(string: NetworkProvider.shared.baseUrl + urlString)
        personImageView.kf.setImage(with: url)
    }
    
    func initPlaceholder() {
        Bundle.main.loadNibNamed("PersonPlaceholder", owner: self, options: nil)
        set(contentView)
    }
    
    func set(_ contentView:UIView) {
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.layer.cornerRadius = frame.height/2
        contentView.layer.borderWidth = 0.3
        contentView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private func commonInit() {
        initPlaceholder()
    }
}
