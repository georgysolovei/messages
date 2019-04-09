//
//  Message.swift
//  message
//
//  Created by mac-167-71 on 4/9/19.
//  Copyright © 2019 home. All rights reserved.
//

import RealmSwift

final class Message: RootObject {
    @objc dynamic var content = ""
    @objc dynamic var updated = ""
    var author: Author!
    
    convenience init(_ messageDTO: MessageDTO) {
        self.init()
        
        id      = messageDTO.id
        content = messageDTO.content
        updated = messageDTO.updated
        author  = Author(messageDTO.author)
    }
}


