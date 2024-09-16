//
//  RadioStreamingFunctions.swift
//  RadioSnap
//
//  Created by Khondwani Sikasote on 2024/09/15.
//

import Foundation

class RadioStreamingFunctions {
    
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
    
    static func getDurationBetweenDates(from startDate: Date, and endDate: Date) -> Int {
        let duration = Calendar.current.dateComponents([.second], from: startDate, to: endDate)
        return duration.second!
    }
    
    static func performMerge(from newStartDateTime: Date, and newEndDateTime: Date, with existingStreamSession: StreamSession, decision: (Int,Bool,Bool)) -> StreamSession {
        if decision.1 == true && decision.2 == false { // we know startDateTime changes
            
            existingStreamSession.startDateTime = newStartDateTime
            existingStreamSession.duration = getDurationBetweenDates(from: existingStreamSession.startDateTime, and: existingStreamSession.endDateTime)
            existingStreamSession.mergeCount += 1
            
            return existingStreamSession
            
        } else if decision.1 == false && decision.2 == true { //when endTime is the one that increases
            existingStreamSession.endDateTime = newEndDateTime
            existingStreamSession.duration = getDurationBetweenDates(from: existingStreamSession.startDateTime, and: existingStreamSession.endDateTime)
            existingStreamSession.mergeCount += 1
            
            return existingStreamSession
        } else if decision.1 == true && decision.2 == true { // bigger start and end time
            existingStreamSession.startDateTime = newStartDateTime
            existingStreamSession.endDateTime = newEndDateTime
            existingStreamSession.duration = getDurationBetweenDates(from: existingStreamSession.startDateTime, and: existingStreamSession.endDateTime)
            existingStreamSession.mergeCount += 1
            return existingStreamSession
        } else {
            // The new times fall in between the times that already exist so it does count as an overlap and merge
            existingStreamSession.mergeCount += 1
            return existingStreamSession
        }
    }
//    static func addToDictNewKeyAndNewStreamSession(currenDict: [String:[StreamSession]], newDictKey: String, newStreamSession: StreamSession) -> [String:[StreamSession]] {
//        
//        return [:]
//    }
//    
//    static func addToStreamSessionArray() {
//        
//    }
    static func compareDatesToSeeIfMergeIsReuired(newStartStreamSession: Date, newEndStreamSession: Date, existingStreamSessions: [StreamSession]) -> Merger { // ifFound, isStartTimeOlder, isEndTimeNewer
        // index means a time was found and we should return the found index.
        // we have two flags to let us know which time (start or end) are we changing to perform the merge
        
        for (index, existingStreamSession) in existingStreamSessions.enumerated() {
           // Edge Case 1: If both start and end are the same
            
            //Example 1
            // newStartSession = 13:00 existingStartDateTime = 13:00
            // newEndSession = 14:00 existingEndDateTime = 14:00
            
            if newStartStreamSession == existingStreamSession.startDateTime && newEndStreamSession == existingStreamSession.endDateTime {
                return Merger(streamSession: index, startTimeMerge: false, endTimeMerge: false) // no need for a merge same session but we record the time
            }
            
            // FOR WHEN NEW STREAM SESSION DATES ARE IN BETWEEN EXISTING STREAM SESSIONS
            // Example 1
            // newStartSession = 13:20 existingStartDateTime = 13:00
            // newEndSession = 13:40 existingEndDateTime = 14:00
            
            if (newStartStreamSession > existingStreamSession.startDateTime && newStartStreamSession < existingStreamSession.endDateTime) && (newEndStreamSession > existingStreamSession.startDateTime && newEndStreamSession < existingStreamSession.endDateTime) {
                return Merger(streamSession: index, startTimeMerge: false, endTimeMerge: false)
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
                return Merger(streamSession: index, startTimeMerge: true, endTimeMerge: false)
            }
            
            //END TIME IS BEING DELT WITH
            //Example 1
            // newStartSession = 13:15 existingStartDateTime = 13:10
            // newEndSession = 14:10 existingEndDateTime = 14:00
            
            //Example 2
            // newStartSession = 13:10 existingStartDateTime = 13:10
            // newEndSession = 14:10 existingEndDateTime = 14:00
            
            if (newStartStreamSession >= existingStreamSession.startDateTime &&  newStartStreamSession < existingStreamSession.endDateTime) && newEndStreamSession > existingStreamSession.endDateTime {
                return Merger(streamSession: index, startTimeMerge: false, endTimeMerge: true)
            }
            
            // EXISITING STREAM SESSION FALLS UNDER THE NEW STREAM SESSION
            // Example 1
            // newStartSession = 13:00 exisitingStartDateTime = 13:30
            // newEndSession = 14:00 existingEndTime = 13:40
            
            if newStartStreamSession < existingStreamSession.startDateTime && newEndStreamSession > existingStreamSession.endDateTime {
                return  Merger(streamSession: index, startTimeMerge: true, endTimeMerge: true)
            }
        }
        
        return  Merger(streamSession: -1, startTimeMerge: false, endTimeMerge: false)
        
    }
    
}
