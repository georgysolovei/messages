//
//  ViewController.swift
//  message
//
//  Created by Georgy Solovei on 4/8/19.
//  Copyright © 2019 home. All rights reserved.
//

import UIKit
import RxSwift

class MessageListView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkProvider.shared.rx.requestData()
            .subscribe()
        
    }
}
