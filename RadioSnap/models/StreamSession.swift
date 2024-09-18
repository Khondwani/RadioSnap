//
//  StreamSession.swift
//  RadioSnap
//
//  Created by Khondwani Sikasote on 2024/09/15.
//

import Foundation
struct StreamSession: Identifiable {
    var id = UUID() // To conform to identifiable
    var startDateTime: Date
    var endDateTime: Date
    var duration: Int // This is time in seconds
    var mergeCount: Int
    var streamName: String // this will allow for viewing perfectly
    
    init(startDateTime: Date, endDateTime: Date, duration: Int, mergeCount: Int = 0, streamName: String) {
        self.startDateTime = startDateTime
        self.endDateTime = endDateTime
        self.duration = duration
        self.mergeCount = mergeCount
        self.streamName = streamName
    }
}
