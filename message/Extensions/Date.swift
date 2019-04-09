//
//  Date.swift
//  message
//
//  Created by mac-167-71 on 4/9/19.
//  Copyright © 2019 home. All rights reserved.
//

import Foundation

extension Date {
    init(dateString: String?, pattern: String, isCurrentTimeZone: Bool = false) {
        let formatter = DateFormatter()
        formatter.timeZone = isCurrentTimeZone ? Calendar.current.timeZone : TimeZone(secondsFromGMT: 0)!
        formatter.dateFormat = pattern
        guard let dateString = dateString else {
            self = Date()
            return
        }
        if let date = formatter.date(from: dateString) {
            self = date
        } else {
            self = Date()
        }
    }
    
    func string(pattern: String, isCurrentTimeZone: Bool = false) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = pattern
        formatter.timeZone = isCurrentTimeZone ? Calendar.current.timeZone : TimeZone(secondsFromGMT: 0)!
        return formatter.string(from: self)
    }
}
