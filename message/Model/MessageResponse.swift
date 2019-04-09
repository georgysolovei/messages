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
    let messages: [MessageDTO]
}

struct MessageDTO: Decodable {
    let content: String
    let updated: String
    let id: Int
    let author: AuthorDTO
}

struct AuthorDTO: Decodable {
    let name: String
    let photoURL: String?
}
