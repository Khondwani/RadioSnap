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
    
    static func secondsToFormatTimeRange(_ seconds: Int) -> String {
        return "\(seconds / 3600) hrs, \((seconds % 3600) / 60) mins, \((seconds % 3600) % 60)s"
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
    
    static func convertDateToString(from date: Date) -> String {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "HH:mm"
           return dateFormatter.string(from: date)
    }
    
    static func getDurationBetweenDates(from startDate: Date, and endDate: Date) -> Int {
        let duration = Calendar.current.dateComponents([.second], from: startDate, to: endDate)
        return duration.second!
    }
    
    static func performMergeWithinMergedStreams(from exisitingMergeStreams: [StreamSession]) -> [StreamSession] {
        // we merge on that specific date in the array if there overlaps
        // EDGE CASE: MERGE WITHIN THE SAME DICTIONARY
        var newMergedStreams: [StreamSession] = []
        var existingMergeStreamsTemp = exisitingMergeStreams
        
        for exisitingMergeStream in exisitingMergeStreams {
            let removed = existingMergeStreamsTemp.removeFirst() // so that it doesnt merge with itself
            // get compare results
            let compareResult = compareDatesToSeeIfMergeIsReuired(newStartStreamSession: exisitingMergeStream.startDateTime, newEndStreamSession: exisitingMergeStream.endDateTime, existingStreamSessions: existingMergeStreamsTemp)
            
            if compareResult.index != -1 {
                
                newMergedStreams.append(performMerge(from: exisitingMergeStream.startDateTime, and: exisitingMergeStream.endDateTime, with: exisitingMergeStream, decision: compareResult))
                
            } else {
                // No Merge Occured so merge Count should be 0
                newMergedStreams.append(performMerge(from: exisitingMergeStream.startDateTime, and: exisitingMergeStream.endDateTime, with: exisitingMergeStream, decision: compareResult))
            }
            
            existingMergeStreamsTemp.append(removed)
        }
        
        return newMergedStreams
    }
    static func performMerge(from newStartDateTime: Date, and newEndDateTime: Date, with existingStreamSession: StreamSession, decision: Merger) -> StreamSession {
        if decision.startTimeMerge == true && decision.endTimeMerge == false { // we know startDateTime changes
            let newMergedStreamSession = StreamSession(startDateTime: newStartDateTime, endDateTime: existingStreamSession.endDateTime, duration: getDurationBetweenDates(from: newStartDateTime, and: existingStreamSession.endDateTime), mergeCount: existingStreamSession.mergeCount + 1, streamName: existingStreamSession.streamName)
            
            return newMergedStreamSession
            
        } else if decision.startTimeMerge == false && decision.endTimeMerge == true { //when endTime is the one that increases
            let newMergedStreamSession = StreamSession(startDateTime: existingStreamSession.startDateTime, endDateTime: newEndDateTime, duration: getDurationBetweenDates(from: existingStreamSession.startDateTime, and: newEndDateTime), mergeCount: existingStreamSession.mergeCount + 1, streamName: existingStreamSession.streamName)
            
            return newMergedStreamSession
            
        } else if decision.startTimeMerge == true && decision.endTimeMerge == true { // bigger start and end time
            let newMergedStreamSession = StreamSession(startDateTime: newStartDateTime, endDateTime: newEndDateTime, duration: getDurationBetweenDates(from: newStartDateTime, and: newEndDateTime), mergeCount: existingStreamSession.mergeCount + 1, streamName: existingStreamSession.streamName)
            return newMergedStreamSession
            
        } else {
            // The new times fall in between the times that already exist so it does count as an overlap and merge
            var newMergedStreamSession: StreamSession? = nil
            if decision.index == -1 { // this is when the perform within merge happens.
                newMergedStreamSession = StreamSession(startDateTime: existingStreamSession.startDateTime, endDateTime: existingStreamSession.endDateTime, duration: getDurationBetweenDates(from: existingStreamSession.startDateTime, and: existingStreamSession.endDateTime), mergeCount: existingStreamSession.mergeCount, streamName: existingStreamSession.streamName)
            } else {
                newMergedStreamSession = StreamSession(startDateTime: existingStreamSession.startDateTime, endDateTime: existingStreamSession.endDateTime, duration: getDurationBetweenDates(from: existingStreamSession.startDateTime, and: existingStreamSession.endDateTime), mergeCount: existingStreamSession.mergeCount + 1, streamName: existingStreamSession.streamName)
            }
            
            return newMergedStreamSession!
        }
    }
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
