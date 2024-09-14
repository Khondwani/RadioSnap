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
    
    struct RadioStreamingFunctions {
        static func findStreamingDate(streamingDate: String, existingStreams:[String:[StreamSession]]) -> [StreamSession] {
            if let existingStream = existingStreams[streamingDate] { // checking if dictionary contains a date that is available.
                return existingStream
            } else {
                return []
            }
        }
        
        static func getSessionDateKey(dictKeyFrom startDate: Date) -> String {
            
            let streamKeyDateFormatter = DateFormatter()
            streamKeyDateFormatter.dateFormat = "dd/MM/yy"
            
            return streamKeyDateFormatter.string(from: startDate)
        }
        
        static func convertStringToDate(from stringDate: String) -> Date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yy HH:mm:ss"
            
            return dateFormatter.date(from: stringDate)!
        }
        
        static func compareDatesToSeeIfMergeIsReuired(newStartStreamSession: Date, newEndStreamSession: Date, existingStreamSessions: [StreamSession]) -> (Int, Bool, Bool) { // ifFound, isStartTimeOlder, isEndTimeNewer
            // index means a time was found and we should return the found index.
            // we have two flags to let us know which time (start or end) are we changing to perform the merge
            
            for (index, existingStreamSession) in existingStreamSessions.enumerated() {
               // Edge Case 1: If both start and end are the same
                
                //Example 1
                // newStartSession = 13:00 existingStartDateTime = 13:00
                // newEndSession = 14:00 existingEndDateTime = 14:00
                
                if newStartStreamSession == existingStreamSession.startDateTime && newEndStreamSession == existingStreamSession.endDateTime {
                    return (index,false,false) // no need for a merge same session but we record the time
                }
                
                // FOR WHEN NEW STREAM SESSION DATES ARE IN BETWEEN EXISTING STREAM SESSIONS
                // Example 1
                // newStartSession = 13:20 existingStartDateTime = 13:00
                // newEndSession = 13:40 existingEndDateTime = 14:00
                
                if (newStartStreamSession > existingStreamSession.startDateTime && newStartStreamSession < existingStreamSession.endDateTime) && (newEndStreamSession > existingStreamSession.startDateTime && newEndStreamSession > existingStreamSession.endDateTime) {
                    return(index,false, false)
                }
                // Check for when Start Time is older than existing stream startTime and endTime is newer than existing starttime and endTime is older than existingEndTime then we know we have a merge.
                
                // START TIME BEING DELT WITH
                //Example 1
                // newStartSession = 13:00 existingStartDateTime = 13:10
                // newEndSession = 13:30 existingEndDateTime = 14:00
                
                //Example 2
                // newStartSession = 13:00 existingStartDateTime = 13:10
                // newEndSession = 14:00 existingEndDateTime = 14:00
                
                if newStartStreamSession < existingStreamSession.startDateTime && (newEndStreamSession > existingStreamSession.startDateTime && newEndStreamSession <= existingStreamSession.endDateTime) {
                    return(index, true, false)
                }
                
                //END TIME IS BEING DELT WITH
                //Example 1
                // newStartSession = 13:15 existingStartDateTime = 13:10
                // newEndSession = 14:10 existingEndDateTime = 14:00
                
                //Example 2
                // newStartSession = 13:10 existingStartDateTime = 13:10
                // newEndSession = 14:10 existingEndDateTime = 14:00
                
                if (newStartStreamSession >= existingStreamSession.startDateTime &&  newStartStreamSession < existingStreamSession.endDateTime) && newEndStreamSession > existingStreamSession.endDateTime {
                    return(index, false, true)
                }
                
                // EXISITING STREAM SESSION FALLS UNDER THE NEW STREAM SESSION
                // Example 1
                // newStartSession = 13:00 exisitingStartDateTime = 13:30
                // newEndSession = 14:00 existingEndTime = 13:40
                
                if newStartStreamSession < existingStreamSession.startDateTime && newEndStreamSession > existingStreamSession.endDateTime {
                    return (index, true, true)
                }
            }
            
            return (-1,false,false)
            
        }
        
    }
    
    func testFindDate_WhenExistingStreamIsEmpty_ShouldReturnEmptyArray() {
        //We only use the start Date as the key to store the start and end datetime
        // Arrange RED-GREEN-REFACTOR
        // just for easier ways to manipulate Dates
        let sut = RadioStreamingFunctions.self
        
        let existingStreams: [String:[StreamSession]] = [:];
        let streamSessionTwoStartDateString = "13/11/24 12:00:00"
     
        // Find Object we need to compare time to retun
        // Act
        let foundListOfStreamsForSpecificDate = sut.findStreamingDate(streamingDate: sut.getSessionDateKey(dictKeyFrom: sut.convertStringToDate(from: streamSessionTwoStartDateString)), existingStreams: existingStreams)
        
        // Assert
        XCTAssertTrue(foundListOfStreamsForSpecificDate.isEmpty, "The array returned had some values, it should be empty")
        
    } 
    
    func testFindDate_WhenExistingStreamArrayHasSessions_ShouldReturnAnArrayForSpecifcKeyDatePassed() {
        // Arrange RED-GREEN-REFACTOR
        // just for easier ways to manipulate Dates
        
        let sut = RadioStreamingFunctions.self
        
        let existingStreams: [String:[StreamSession]] = ["13/11/24":[StreamSession(startDateTime: sut.convertStringToDate(from: "13/11/24 12:30:00"), endDateTime: sut.convertStringToDate(from:  "13/11/24 13:00:00"), duration: 0.5, mergeCount: 0)]]
        
        let streamSessionTwoStartDateString = "13/11/24 12:00:00"
        let streamSessionTwoEndDateString = "13/11/24 12:00:00"
        
        let streamSessionTwoStartDate = sut.convertStringToDate(from: streamSessionTwoStartDateString)
        let _ = sut.convertStringToDate(from: streamSessionTwoEndDateString)
        
        // Find Object we need to compare time to retun
        // Act
     
        let foundListOfStreamsForSpecificDate = sut.findStreamingDate(streamingDate: sut.getSessionDateKey(dictKeyFrom: streamSessionTwoStartDate), existingStreams: existingStreams)
        
        // Assert
        XCTAssertFalse(foundListOfStreamsForSpecificDate.isEmpty, "The dictionary should contain the key passed, currently returning an empty array")
        
    }
    
    func testCompareFunction_WhenExistingStreamArrayHasAMergeBasedOnStartDate_ShouldReturnATupleWithIndexAndTrueAndFalse() {
        // RED-GREEN-REFACTOR
        
        // Arrange
        let sut = RadioStreamingFunctions.self

        let existingStreams: [String:[StreamSession]] = ["13/11/24":[StreamSession(startDateTime: sut.convertStringToDate(from: "13/11/24 12:30:00"), endDateTime: sut.convertStringToDate(from:  "13/11/24 13:00:00"), duration: 0.5, mergeCount: 0)]]
        
        let newStreamSessionStartDate = sut.convertStringToDate(from: "13/11/24 12:00:00")
        let newStreamSessionEndDate = sut.convertStringToDate(from: "13/11/24 12:40:00")
        
        
        let expect = (0,true,false) // tells me
        // Find Object we need to compare time to retun
        // Act
     
        let arrayOfStreamSessionForSpecificDate = sut.findStreamingDate(streamingDate: sut.getSessionDateKey(dictKeyFrom: newStreamSessionStartDate), existingStreams: existingStreams)
        
        let actual = sut.compareDatesToSeeIfMergeIsReuired(newStartStreamSession: newStreamSessionStartDate, newEndStreamSession: newStreamSessionEndDate, existingStreamSessions: arrayOfStreamSessionForSpecificDate)
        
        // Assert
        XCTAssertEqual(actual.0, expect.0, "Int value should be 0 but given \(actual.0)" )
        XCTAssertEqual(actual.1, expect.1, "Bool value should be True but given \(actual.1)" )
        XCTAssertEqual(actual.2, expect.2, "Bool value should be Fasle but given \(actual.2)" )
        
    }
}
