//
//  Coordinator.swift
//  message
//
//  Created by mac-167-71 on 4/9/19.
//  Copyright © 2019 home. All rights reserved.
//

import UIKit

class Coordinator {
    
    init(_ window: UIWindow) {
        let messageListViewModel = MessageListViewModel()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController")
        
        let messageListView = navigationController.children.first as! MessageListView
        messageListView.viewModel = messageListViewModel
       
        window.rootViewController = navigationController
    }
}
