//
//  MessageResponse.swift
//  message
//
//  Created by Georgy Solovei on 4/9/19.
//  Copyright © 2019 home. All rights reserved.
//

import Foundation
import RxDataSources

struct MessageResponse: Decodable {
    let count: Int
    let pageToken: String
    let messages: [MessageDTO]
}



