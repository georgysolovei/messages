//
//  Section.swift
//  message
//
//  Created by Georgy Solovei on 4/9/19.
//  Copyright © 2019 home. All rights reserved.
//

import Foundation
import RxDataSources

struct Section {
    var header: String
    var items: [Item]
}

extension Section: SectionModelType {
    typealias Item = MessageDTO
    
    init(original: Section, items: [MessageDTO]) {
        self = original
        self.items = items
    }
}
