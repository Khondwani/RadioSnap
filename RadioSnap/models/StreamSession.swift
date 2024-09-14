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
    var duration: Double // This is time in hours
    var mergeCount: Int
    
    init(startDateTime: Date, endDateTime: Date, duration: Double, mergeCount: Int) {
        self.startDateTime = startDateTime
        self.endDateTime = endDateTime
        self.duration = duration
        self.mergeCount = mergeCount
    }
}
