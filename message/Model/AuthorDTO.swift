//
//  AuthorDTO.swift
//  message
//
//  Created by Georgy Solovei on 4/9/19.
//  Copyright © 2019 home. All rights reserved.
//

import Foundation

struct AuthorDTO: Decodable {
    let name: String
    let photoUrl: String?
}
