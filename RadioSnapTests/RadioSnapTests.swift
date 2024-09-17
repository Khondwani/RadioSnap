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
        
        existingStreams = ["13/11/24":[StreamSession(startDateTime: RadioStreamingFunctions.convertStringToDate(from: "13/11/24 12:30:00"), endDateTime: RadioStreamingFunctions.convertStringToDate(from:  "13/11/24 13:00:00"), duration: 1800, mergeCount: 0)]]
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
        
        
        let expect = Merger(streamSession:0,startTimeMerge:true,endTimeMerge:false) // tells me
        // Find Object we need to compare time to retun
        // Act
     
        let arrayOfStreamSessionForSpecificDate = RadioStreamingFunctions.findStreamingDate(streamingDate: RadioStreamingFunctions.getSessionDateKey(dictKeyFrom: newStreamSessionStartDate), existingStreams: existingStreams)
        
        let actual = RadioStreamingFunctions.compareDatesToSeeIfMergeIsReuired(newStartStreamSession: newStreamSessionStartDate, newEndStreamSession: newStreamSessionEndDate, existingStreamSessions: arrayOfStreamSessionForSpecificDate)
        
        // Assert
        XCTAssertEqual(actual.index, expect.index, "Int value should be 0 but given \(actual.index)" )
        XCTAssertEqual(actual.startTimeMerge, expect.startTimeMerge, "Bool value should be TRUE but given \(actual.startTimeMerge)" )
        XCTAssertEqual(actual.endTimeMerge, expect.endTimeMerge, "Bool value should be FALSE but given \(actual.endTimeMerge)" )
        
    }
    
    func testCompareFunction_WhenExistingStreamArrayHasAMergeBasedOnEndDate_ShouldReturnATupleWithIndex0AndFalseAndTrue() {
        // RED-GREEN-REFACTOR
        
        // Arrange
        
        //EXISTING DATE: START = 12:30 END = 13:00
        let newStreamSessionStartDate = RadioStreamingFunctions.convertStringToDate(from: "13/11/24 12:35:10")
        let newStreamSessionEndDate = RadioStreamingFunctions.convertStringToDate(from: "13/11/24 13:00:01")
        
        
        let expect = Merger(streamSession:0,startTimeMerge:false,endTimeMerge:true) // Tells me at index 0 on that date we have a merge with the endDate changing to the new Date.
        // Act
     
        let arrayOfStreamSessionForSpecificDate = RadioStreamingFunctions.findStreamingDate(streamingDate: RadioStreamingFunctions.getSessionDateKey(dictKeyFrom: newStreamSessionStartDate), existingStreams: existingStreams)
        
        let actual = RadioStreamingFunctions.compareDatesToSeeIfMergeIsReuired(newStartStreamSession: newStreamSessionStartDate, newEndStreamSession: newStreamSessionEndDate, existingStreamSessions: arrayOfStreamSessionForSpecificDate)
        
        // Assert
        XCTAssertEqual(actual.index, expect.index, "Int value should be 0 but given \(actual.index)" )
        XCTAssertEqual(actual.startTimeMerge, expect.startTimeMerge, "Bool value should be FALSE but given \(actual.startTimeMerge)" )
        XCTAssertEqual(actual.endTimeMerge, expect.endTimeMerge, "Bool value should be TRUE but given \(actual.endTimeMerge)" )
        
    }
    
    func testCompareFunction_WhenExistingStreamArrayHasAMergeBasedOnStartAndEndDateBeingLarger_ShouldReturnATupleWithIndex0AndTrueAndTrue() {
        // RED-GREEN-REFACTOR
        
        // Arrange
        
        //EXISTING DATE: START = 12:30 END = 13:00
        let newStreamSessionStartDate = RadioStreamingFunctions.convertStringToDate(from: "13/11/24 12:29:59")
        let newStreamSessionEndDate = RadioStreamingFunctions.convertStringToDate(from: "13/11/24 13:00:01")
        
        
        let expect = Merger(streamSession:0,startTimeMerge:true,endTimeMerge:true)// Tells me at index 0 on that date we have a merge with the start date and end date changing.
        // Act
     
        let arrayOfStreamSessionForSpecificDate = RadioStreamingFunctions.findStreamingDate(streamingDate: RadioStreamingFunctions.getSessionDateKey(dictKeyFrom: newStreamSessionStartDate), existingStreams: existingStreams)
        
        let actual = RadioStreamingFunctions.compareDatesToSeeIfMergeIsReuired(newStartStreamSession: newStreamSessionStartDate, newEndStreamSession: newStreamSessionEndDate, existingStreamSessions: arrayOfStreamSessionForSpecificDate)
        
        // Assert
        XCTAssertEqual(actual.index, expect.index, "Int value should be 0 but given \(actual.index)" )
        XCTAssertEqual(actual.startTimeMerge, expect.startTimeMerge, "Bool value should be TRUE but given \(actual.startTimeMerge)" )
        XCTAssertEqual(actual.endTimeMerge, expect.endTimeMerge, "Bool value should be TRUE but given \(actual.endTimeMerge)" )
        
    }
    
    func testCompareFunction_WhenExistingStreamArrayHasAMergeBasedOnStartAndEndDateBeingSmaller_ShouldReturnATupleWithIndex0AndFalseAndFalse() {
        // RED-GREEN-REFACTOR
        
        // Arrange
        
        //EXISTING DATE: START = 12:30 END = 13:00
        let newStreamSessionStartDate = RadioStreamingFunctions.convertStringToDate(from: "13/11/24 12:30:59")
        let newStreamSessionEndDate = RadioStreamingFunctions.convertStringToDate(from: "13/11/24 12:59:59")
        
        
        let expect = Merger(streamSession:0,startTimeMerge:false,endTimeMerge:false) // Tells me at index 0 on that date we have a merge with the start date and end date changing.
        // Act
     
        let arrayOfStreamSessionForSpecificDate = RadioStreamingFunctions.findStreamingDate(streamingDate: RadioStreamingFunctions.getSessionDateKey(dictKeyFrom: newStreamSessionStartDate), existingStreams: existingStreams)
        
        let actual = RadioStreamingFunctions.compareDatesToSeeIfMergeIsReuired(newStartStreamSession: newStreamSessionStartDate, newEndStreamSession: newStreamSessionEndDate, existingStreamSessions: arrayOfStreamSessionForSpecificDate)
        
        // Assert
        XCTAssertEqual(actual.index, expect.index, "Int value should be 0 but given \(actual.index)" )
        XCTAssertEqual(actual.startTimeMerge, expect.startTimeMerge, "Bool value should be FALSE but given \(actual.startTimeMerge)" )
        XCTAssertEqual(actual.endTimeMerge, expect.endTimeMerge, "Bool value should be FALSE but given \(actual.endTimeMerge)" )
        
    }
    func testCompareFunction_WhenExistingStreamArrayHasAMergeBasedOnStartAndEndDateBeingTheSame_ShouldReturnATupleWithIndex0AndFalseAndFalse() {
        // RED-GREEN-REFACTOR
        
        // Arrange
        
        //EXISTING DATE: START = 12:30 END = 13:00
        let newStreamSessionStartDate = RadioStreamingFunctions.convertStringToDate(from: "13/11/24 12:30:00")
        let newStreamSessionEndDate = RadioStreamingFunctions.convertStringToDate(from: "13/11/24 13:00:00")
        
        
        let expect = Merger(streamSession:0,startTimeMerge:false,endTimeMerge:false)        // Act
     
        let arrayOfStreamSessionForSpecificDate = RadioStreamingFunctions.findStreamingDate(streamingDate: RadioStreamingFunctions.getSessionDateKey(dictKeyFrom: newStreamSessionStartDate), existingStreams: existingStreams)
        
        let actual = RadioStreamingFunctions.compareDatesToSeeIfMergeIsReuired(newStartStreamSession: newStreamSessionStartDate, newEndStreamSession: newStreamSessionEndDate, existingStreamSessions: arrayOfStreamSessionForSpecificDate)
        
        // Assert
        XCTAssertEqual(actual.index, expect.index, "Int value should be 0 but given \(actual.index)" )
        XCTAssertEqual(actual.startTimeMerge, expect.startTimeMerge, "Bool value should be FALSE but given \(actual.startTimeMerge)" )
        XCTAssertEqual(actual.endTimeMerge, expect.endTimeMerge, "Bool value should be FALSE but given \(actual.endTimeMerge)" )
        
    }  
    func testCompareFunction_WhenExistingStreamArrayHasAMergeBasedOnStartAndEndDateBeingTheSame_ShouldReturnATupleWithnIndexNegative1AndFalseAndFalse() {
        // RED-GREEN-REFACTOR
        
        // Arrange
        
        //EXISTING DATE: START = 12:30 END = 13:00
        let newStreamSessionStartDate = RadioStreamingFunctions.convertStringToDate(from: "13/11/24 11:30:00")
        let newStreamSessionEndDate = RadioStreamingFunctions.convertStringToDate(from: "13/11/24 12:00:00")
        
        
        let expect = Merger(streamSession:-1,startTimeMerge:false,endTimeMerge:false) // Tells me it did not find a time to merge into so we just put it in the array.
     
        let arrayOfStreamSessionForSpecificDate = RadioStreamingFunctions.findStreamingDate(streamingDate: RadioStreamingFunctions.getSessionDateKey(dictKeyFrom: newStreamSessionStartDate), existingStreams: existingStreams)
        
        let actual = RadioStreamingFunctions.compareDatesToSeeIfMergeIsReuired(newStartStreamSession: newStreamSessionStartDate, newEndStreamSession: newStreamSessionEndDate, existingStreamSessions: arrayOfStreamSessionForSpecificDate)
        
        // Assert
        XCTAssertEqual(actual.index, expect.index, "Int value should be -1 but given \(actual.index)" )
        XCTAssertEqual(actual.startTimeMerge, expect.startTimeMerge, "Bool value should be FALSE but given \(actual.startTimeMerge)" )
        XCTAssertEqual(actual.endTimeMerge, expect.endTimeMerge, "Bool value should be FALSE but given \(actual.endTimeMerge)" )
        
    }
    
    func testCompareFunction_WhenExistingStreamArrayHasAMergeBasedOnStartAndEndDateBeingTheSame_ShouldReturnATupleWithnIndex1AndTrueAndFalse() {
        // RED-GREEN-REFACTOR
        
        // Arrange
        
        //EXISTING DATE: START = 12:30 END = 13:00
        let newStreamSessionStartDate = RadioStreamingFunctions.convertStringToDate(from: "13/11/24 13:00:00")
        let newStreamSessionEndDate = RadioStreamingFunctions.convertStringToDate(from: "13/11/24 14:31:00")
        
        existingStreams["13/11/24"]?.append(StreamSession(startDateTime: RadioStreamingFunctions.convertStringToDate(from: "13/11/24 14:30:00"), endDateTime: RadioStreamingFunctions.convertStringToDate(from:  "13/11/24 15:00:00"), duration: 0))
        
        let expect = Merger(streamSession:1,startTimeMerge:true,endTimeMerge:false)
     
        let arrayOfStreamSessionForSpecificDate = RadioStreamingFunctions.findStreamingDate(streamingDate: RadioStreamingFunctions.getSessionDateKey(dictKeyFrom: newStreamSessionStartDate), existingStreams: existingStreams)
        
        let actual = RadioStreamingFunctions.compareDatesToSeeIfMergeIsReuired(newStartStreamSession: newStreamSessionStartDate, newEndStreamSession: newStreamSessionEndDate, existingStreamSessions: arrayOfStreamSessionForSpecificDate)
        
        // Assert
        XCTAssertEqual(actual.index, expect.index, "Int value should be 1 but given \(actual.index)" )
        XCTAssertEqual(actual.startTimeMerge, expect.startTimeMerge, "Bool value should be TRUE but given \(actual.startTimeMerge)" )
        XCTAssertEqual(actual.endTimeMerge, expect.endTimeMerge, "Bool value should be FALSE but given \(actual.endTimeMerge)" )
        
    }
    
    func testMergerFunction_WhenNewStreamStartDateIsOlderThanExistingStartDate_ShouldReturnNewMergedSessionWithDuration() {
        
        // RED-GREEN-REFACTOR
        
        // Arrange
        //EXISTING DATE: START = 12:30 END = 13:00
        let newStreamSessionStartDate = RadioStreamingFunctions.convertStringToDate(from: "13/11/24 12:00:00")
        let newStreamSessionEndDate = RadioStreamingFunctions.convertStringToDate(from: "13/11/24 12:40:00")
        
        
        let expectedStreamSession = StreamSession(startDateTime: RadioStreamingFunctions.convertStringToDate(from: "13/11/24 12:00:00"), endDateTime: RadioStreamingFunctions.convertStringToDate(from:  "13/11/24 13:00:00"), duration: 3600, mergeCount: 1) // tells me
        // Act
        // we not testing adding to the array we testing merging on a value that already exists
        let newExistingStreamSession = RadioStreamingFunctions.performMerge(from: newStreamSessionStartDate, and: newStreamSessionEndDate, with: (existingStreams["13/11/24"]! as [StreamSession])[0], decision: Merger(streamSession: 0, startTimeMerge: true, endTimeMerge: false))
        
        XCTAssertEqual(newExistingStreamSession.duration, expectedStreamSession.duration, "The duration must be \(expectedStreamSession.duration), but was given \(newExistingStreamSession.duration)")
            
    
        
        
        
        
        // Assert
//        XCTAssertEqual(actual.0, expect.0, "Int value should be 0 but given \(actual.0)" )
//        XCTAssertEqual(actual.1, expect.1, "Bool value should be TRUE but given \(actual.1)" )
//        XCTAssertEqual(actual.2, expect.2, "Bool value should be FALSE but given \(actual.2)" )
    }
    // Tested the function with Hours it would exclude the minutes and seconds, did the same with minutes it would get the hour and minute correct but as soon as we add the seconds it excludes it! So its better to convert it to Seconds so that we get a correct duration calculation!
    func testGetDurationFunction_WhenAMergeOccursAndDurationChanges_ShouldReturnDurationValueInSeconds(){
        // Arrange
        let dateOne = RadioStreamingFunctions.convertStringToDate(from: "13/11/24 12:00:00")
        let dateTwo = RadioStreamingFunctions.convertStringToDate(from: "13/11/24 14:30:30")
        // Act
        
        let actualDuration = RadioStreamingFunctions.getDurationBetweenDates(from: dateOne, and: dateTwo)
        let expectedDuration = 9030
        
      
        XCTAssertEqual(actualDuration, expectedDuration, "Duration (Seconds) value should be \(expectedDuration) but given \(actualDuration)" )
   
        
    }
}
