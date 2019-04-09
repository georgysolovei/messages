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

struct MessageDTO: Decodable, IdentifiableType, Equatable {
    static func == (lhs: MessageDTO, rhs: MessageDTO) -> Bool {
        return lhs.id == rhs.id
    }
    
    typealias Identity = String
    var identity: String {
        return updated
    }
    let content: String
    let updated: String
    let id: Int
    let author: AuthorDTO
}

struct AuthorDTO: Decodable {
    let name: String
    let photoUrl: String?
}
