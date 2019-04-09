//
//  RootObject.swift
//  message
//
//  Created by mac-167-71 on 4/9/19.
//  Copyright © 2019 home. All rights reserved.
//

import RealmSwift

class RootObject: Object {
    @objc dynamic var id = 0
    //    @objc dynamic var isPending = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
