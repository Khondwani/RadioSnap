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
            
            if (newStartStreamSession > existingStreamSession.startDateTime && newStartStreamSession < existingStreamSession.endDateTime) && (newEndStreamSession > existingStreamSession.startDateTime && newEndStreamSession < existingStreamSession.endDateTime) {
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
