//
//  Author.swift
//  message
//
//  Created by mac-167-71 on 4/9/19.
//  Copyright © 2019 home. All rights reserved.
//

import RealmSwift

final class Author: RootObject {
    @objc dynamic var name = ""
    @objc dynamic var photoURL: String?
    
    convenience init(_ authorDTO: AuthorDTO) {
        self.init()

        id       = uniqueIntNumber()
        name     = authorDTO.name
        photoURL = authorDTO.photoURL
    }
}
