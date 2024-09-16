//
//  StreamSession.swift
//  RadioSnap
//
//  Created by Khondwani Sikasote on 2024/09/15.
//

import Foundation
class StreamSession {
    var startDateTime: Date
    var endDateTime: Date
    var duration: Int // This is time in seconds
    var mergeCount: Int
    
    init(startDateTime: Date, endDateTime: Date, duration: Int, mergeCount: Int = 0) {
        self.startDateTime = startDateTime
        self.endDateTime = endDateTime
        self.duration = duration
        self.mergeCount = mergeCount
    }
}
