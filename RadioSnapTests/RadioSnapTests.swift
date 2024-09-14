//
//  RadioSnapTests.swift
//  RadioSnapTests
//
//  Created by Khondwani Sikasote on 2024/09/14.
//

import XCTest
@testable import RadioSnap

final class RadioSnapTests: XCTestCase {
    
    // SYSTEM UNDER TEST => RadioStreamingFunctions
    var existingStreams: [String:[StreamSession]] = [:]
    
    override func setUp() {
        
        existingStreams = ["13/11/24":[StreamSession(startDateTime: RadioStreamingFunctions.convertStringToDate(from: "13/11/24 12:30:00"), endDateTime: RadioStreamingFunctions.convertStringToDate(from:  "13/11/24 13:00:00"), duration: 0.5, mergeCount: 0)]]
    }
    
    func testFindDate_WhenExistingStreamIsEmpty_ShouldReturnEmptyArray() {
        //We only use the start Date as the key to store the start and end datetime
        // Arrange RED-GREEN-REFACTOR
        
        let existingStreams: [String:[StreamSession]] = [:];
        let streamSessionTwoStartDateString = "13/11/24 12:00:00"
     
        // Find Object we need to compare time to retun
        // Act
        let foundListOfStreamsForSpecificDate = RadioStreamingFunctions.findStreamingDate(streamingDate: RadioStreamingFunctions.getSessionDateKey(dictKeyFrom: RadioStreamingFunctions.convertStringToDate(from: streamSessionTwoStartDateString)), existingStreams: existingStreams)
        
        // Assert
        XCTAssertTrue(foundListOfStreamsForSpecificDate.isEmpty, "The array returned had some values, it should be empty")
        
    } 
    
    func testFindDate_WhenExistingStreamArrayHasSessions_ShouldReturnAnArrayForSpecifcKeyDatePassed() {
        // Arrange RED-GREEN-REFACTOR
        // just for easier ways to manipulate Dates
        
        let streamSessionTwoStartDateString = "13/11/24 12:00:00"
        let streamSessionTwoEndDateString = "13/11/24 12:00:00"
        
        let streamSessionTwoStartDate = RadioStreamingFunctions.convertStringToDate(from: streamSessionTwoStartDateString)
        let _ = RadioStreamingFunctions.convertStringToDate(from: streamSessionTwoEndDateString)
        
        // Find Object we need to compare time to retun
        // Act
     
        let foundListOfStreamsForSpecificDate = RadioStreamingFunctions.findStreamingDate(streamingDate: RadioStreamingFunctions.getSessionDateKey(dictKeyFrom: streamSessionTwoStartDate), existingStreams: existingStreams)
        
        // Assert
        XCTAssertFalse(foundListOfStreamsForSpecificDate.isEmpty, "The dictionary should contain the key passed, currently returning an empty array")
        
    }
    
    func testCompareFunction_WhenExistingStreamArrayHasAMergeBasedOnStartDate_ShouldReturnATupleWithIndex0AndTrueAndFalse() {
        // RED-GREEN-REFACTOR
        
        // Arrange
        
        let newStreamSessionStartDate = RadioStreamingFunctions.convertStringToDate(from: "13/11/24 12:00:00")
        let newStreamSessionEndDate = RadioStreamingFunctions.convertStringToDate(from: "13/11/24 12:40:00")
        
        
        let expect = (0,true,false) // tells me
        // Find Object we need to compare time to retun
        // Act
     
        let arrayOfStreamSessionForSpecificDate = RadioStreamingFunctions.findStreamingDate(streamingDate: RadioStreamingFunctions.getSessionDateKey(dictKeyFrom: newStreamSessionStartDate), existingStreams: existingStreams)
        
        let actual = RadioStreamingFunctions.compareDatesToSeeIfMergeIsReuired(newStartStreamSession: newStreamSessionStartDate, newEndStreamSession: newStreamSessionEndDate, existingStreamSessions: arrayOfStreamSessionForSpecificDate)
        
        // Assert
        XCTAssertEqual(actual.0, expect.0, "Int value should be 0 but given \(actual.0)" )
        XCTAssertEqual(actual.1, expect.1, "Bool value should be TRUE but given \(actual.1)" )
        XCTAssertEqual(actual.2, expect.2, "Bool value should be FALSE but given \(actual.2)" )
        
    }
    
    func testCompareFunction_WhenExistingStreamArrayHasAMergeBasedOnEndDate_ShouldReturnATupleWithIndex0AndFalseAndTrue() {
        // RED-GREEN-REFACTOR
        
        // Arrange
        
        //EXISTING DATE: START = 12:30 END = 13:00
        let newStreamSessionStartDate = RadioStreamingFunctions.convertStringToDate(from: "13/11/24 12:35:10")
        let newStreamSessionEndDate = RadioStreamingFunctions.convertStringToDate(from: "13/11/24 13:00:01")
        
        
        let expect = (0,false,true) // Tells me at index 0 on that date we have a merge with the endDate changing to the new Date.
        // Act
     
        let arrayOfStreamSessionForSpecificDate = RadioStreamingFunctions.findStreamingDate(streamingDate: RadioStreamingFunctions.getSessionDateKey(dictKeyFrom: newStreamSessionStartDate), existingStreams: existingStreams)
        
        let actual = RadioStreamingFunctions.compareDatesToSeeIfMergeIsReuired(newStartStreamSession: newStreamSessionStartDate, newEndStreamSession: newStreamSessionEndDate, existingStreamSessions: arrayOfStreamSessionForSpecificDate)
        
        // Assert
        XCTAssertEqual(actual.0, expect.0, "Int value should be 0 but given \(actual.0)" )
        XCTAssertEqual(actual.1, expect.1, "Bool value should be FALSE but given \(actual.1)" )
        XCTAssertEqual(actual.2, expect.2, "Bool value should be TRUE but given \(actual.2)" )
        
    }
    
    func testCompareFunction_WhenExistingStreamArrayHasAMergeBasedOnStartAndEndDateBeingLarger_ShouldReturnATupleWithIndex0AndTrueAndTrue() {
        // RED-GREEN-REFACTOR
        
        // Arrange
        
        //EXISTING DATE: START = 12:30 END = 13:00
        let newStreamSessionStartDate = RadioStreamingFunctions.convertStringToDate(from: "13/11/24 12:29:59")
        let newStreamSessionEndDate = RadioStreamingFunctions.convertStringToDate(from: "13/11/24 13:00:01")
        
        
        let expect = (0,true,true) // Tells me at index 0 on that date we have a merge with the start date and end date changing.
        // Act
     
        let arrayOfStreamSessionForSpecificDate = RadioStreamingFunctions.findStreamingDate(streamingDate: RadioStreamingFunctions.getSessionDateKey(dictKeyFrom: newStreamSessionStartDate), existingStreams: existingStreams)
        
        let actual = RadioStreamingFunctions.compareDatesToSeeIfMergeIsReuired(newStartStreamSession: newStreamSessionStartDate, newEndStreamSession: newStreamSessionEndDate, existingStreamSessions: arrayOfStreamSessionForSpecificDate)
        
        // Assert
        XCTAssertEqual(actual.0, expect.0, "Int value should be 0 but given \(actual.0)" )
        XCTAssertEqual(actual.1, expect.1, "Bool value should be TRUE but given \(actual.1)" )
        XCTAssertEqual(actual.2, expect.2, "Bool value should be TRUE but given \(actual.2)" )
        
    }
    
    func testCompareFunction_WhenExistingStreamArrayHasAMergeBasedOnStartAndEndDateBeingSmaller_ShouldReturnATupleWithIndex0AndFalseAndFalse() {
        // RED-GREEN-REFACTOR
        
        // Arrange
        
        //EXISTING DATE: START = 12:30 END = 13:00
        let newStreamSessionStartDate = RadioStreamingFunctions.convertStringToDate(from: "13/11/24 12:30:59")
        let newStreamSessionEndDate = RadioStreamingFunctions.convertStringToDate(from: "13/11/24 12:59:59")
        
        
        let expect = (0,false,false) // Tells me at index 0 on that date we have a merge with the start date and end date changing.
        // Act
     
        let arrayOfStreamSessionForSpecificDate = RadioStreamingFunctions.findStreamingDate(streamingDate: RadioStreamingFunctions.getSessionDateKey(dictKeyFrom: newStreamSessionStartDate), existingStreams: existingStreams)
        
        let actual = RadioStreamingFunctions.compareDatesToSeeIfMergeIsReuired(newStartStreamSession: newStreamSessionStartDate, newEndStreamSession: newStreamSessionEndDate, existingStreamSessions: arrayOfStreamSessionForSpecificDate)
        
        // Assert
        XCTAssertEqual(actual.0, expect.0, "Int value should be 0 but given \(actual.0)" )
        XCTAssertEqual(actual.1, expect.1, "Bool value should be FALSE but given \(actual.1)" )
        XCTAssertEqual(actual.2, expect.2, "Bool value should be FALSE but given \(actual.2)" )
        
    }
    func testCompareFunction_WhenExistingStreamArrayHasAMergeBasedOnStartAndEndDateBeingTheSame_ShouldReturnATupleWithIndex0AndFalseAndFalse() {
        // RED-GREEN-REFACTOR
        
        // Arrange
        
        //EXISTING DATE: START = 12:30 END = 13:00
        let newStreamSessionStartDate = RadioStreamingFunctions.convertStringToDate(from: "13/11/24 12:30:00")
        let newStreamSessionEndDate = RadioStreamingFunctions.convertStringToDate(from: "13/11/24 13:00:00")
        
        
        let expect = (0,false,false) // Tells me at index 0 on that date we have a merge with the start date and end date changing.
        // Act
     
        let arrayOfStreamSessionForSpecificDate = RadioStreamingFunctions.findStreamingDate(streamingDate: RadioStreamingFunctions.getSessionDateKey(dictKeyFrom: newStreamSessionStartDate), existingStreams: existingStreams)
        
        let actual = RadioStreamingFunctions.compareDatesToSeeIfMergeIsReuired(newStartStreamSession: newStreamSessionStartDate, newEndStreamSession: newStreamSessionEndDate, existingStreamSessions: arrayOfStreamSessionForSpecificDate)
        
        // Assert
        XCTAssertEqual(actual.0, expect.0, "Int value should be 0 but given \(actual.0)" )
        XCTAssertEqual(actual.1, expect.1, "Bool value should be FALSE but given \(actual.1)" )
        XCTAssertEqual(actual.2, expect.2, "Bool value should be FALSE but given \(actual.2)" )
        
    }
}
