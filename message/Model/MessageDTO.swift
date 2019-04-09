//
//  MessageDTO.swift
//  message
//
//  Created by Georgy Solovei on 4/9/19.
//  Copyright © 2019 home. All rights reserved.
//

import Foundation
import RxDataSources

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
