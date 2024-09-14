//
//  RadioSnapTests.swift
//  RadioSnapTests
//
//  Created by Khondwani Sikasote on 2024/09/14.
//

import XCTest
@testable import RadioSnap

final class RadioSnapTests: XCTestCase {
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
    
//    struct RadioStreamingFunctions {
//        static func findStreamingDate(streamingDate: String) {
//            
//        }
//    }
    
    func testMergeTimesFunctionOnSameDay_WhenTimeIsNotInRange_ShouldReturnNoDateTimeObj() {
        // Arrange RED-GREEN-REFACTOR
        // just for easier ways to manipulate Dates
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy HH:mm:ss" 
        
        let streamKeyDateFormatter = DateFormatter()
        streamKeyDateFormatter.dateFormat = "dd/MM/yy"
        
        let streamSessionOneStartDateString = "13/11/24 12:30:00"
        let streamSessionOneEndDateString = "13/11/24 13:00:00"
        
        let streamSessionOneStartDate = dateFormatter.date(from: streamSessionOneStartDateString)!
        let streamSessionOneEndDate = dateFormatter.date(from: streamSessionOneEndDateString)!
        
        let existingStreams: [String:[StreamSession]] = ["13/11/24":[StreamSession(startDateTime: streamSessionOneStartDate, endDateTime: streamSessionOneEndDate, duration: 0.5, mergeCount: 0)]]
        
        let streamSessionTwoStartDateString = "13/11/24 12:00:00"
        let streamSessionTwoEndDateString = "13/11/24 12:00:00"
        
        let streamSessionTwoStartDate = dateFormatter.date(from: streamSessionTwoStartDateString)!
        let streamSessionTwoEndDate = dateFormatter.date(from: streamSessionTwoEndDateString)!
        
        // Find Object we need to compare time to retun
        let sut = RadioStreamingFunctions.self
        sut.findStreamingDate(streamingDate: streamingSessionTwo.)
        
        // Assert
        
        
        let startTime =
        let sut = Merger();
        // Act
        sut.mergeTime(startTime:, endTime: , existingStreams: );
        
    }
}
