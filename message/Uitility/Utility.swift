//
//  Utility.swift
//  message
//
//  Created by mac-167-71 on 4/9/19.
//  Copyright © 2019 home. All rights reserved.
//

import Foundation

let serverDatePattern  = "yyyy-MM-dd'T'HH:mm:ssxxxxx"
let longLiteralPattern = "h:mm a, MMMM d, yyyy"

func uniqueIntNumber() -> Int {
    let date = Date()
    let uniqueNumber = date.timeIntervalSince1970 * 1_000
    return Int(uniqueNumber)
}
