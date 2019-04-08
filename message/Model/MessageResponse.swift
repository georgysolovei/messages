//
//  MessageResponse.swift
//  message
//
//  Created by Georgy Solovei on 4/9/19.
//  Copyright © 2019 home. All rights reserved.
//

import Foundation

struct MessageResponse: Decodable {
    let count: Int
    let pageToken: String
    let messages: [Message]
}

struct Message: Decodable {
    let content: String
    let updated: String
    let id: Int
    let author: Author
}

struct Author: Decodable {
    let name: String
    let photoURL: String?
}
