//
//  Streams.swift
//  RadioSnap
//
//  Created by Khondwani Sikasote on 2024/09/17.
//

import Foundation

class Streams: ObservableObject, Identifiable {
    
    static let sharedInstance = Streams()
    
    @Published var streams: [String:[StreamSession]] = [:] // if anything changes in it an update occors
    
    @Published var mergedStreams: [String:[StreamSession]] = [:] // only for merges that is what this will keep
    // pass by reference happens when you pass a class instance!!! This made me get bugs
    // adding inout causes a copy to be passed instead!! which fixed my bug
    func addNewStreamSession(key dictKey: String, value newStream:  StreamSession) {
        if streams[dictKey] != nil {
            // we add the new stream to the array that is already there.
            streams[dictKey]!.append(newStream)
        } else {
            streams[dictKey] = [newStream] // add
        }
    }
    
    func addToMergedStreamSessions(key dictKey: String, value newStream: StreamSession) {
        if mergedStreams[dictKey] != nil {
            // we do not add it immediately. we find the index for the dictKey first

        let mergeResult = RadioStreamingFunctions.compareDatesToSeeIfMergeIsReuired(newStartStreamSession: newStream.startDateTime, newEndStreamSession: newStream.endDateTime, existingStreamSessions: mergedStreams[dictKey]!)
            
            if mergeResult.index != -1 { // we know a time range has been found for merge so we merge
                
                let oldStream = mergedStreams[dictKey]![mergeResult.index]
                
                let newMergedStream = RadioStreamingFunctions.performMerge(from: newStream.startDateTime, and: newStream.endDateTime, with: oldStream, decision: mergeResult)
                
                // replace the oldStream with the newMerged Stream
                mergedStreams[dictKey]![mergeResult.index] = newMergedStream
                // Do it when we have more than 2 to always make sure merge happens
                mergedStreams[dictKey] = RadioStreamingFunctions.performMergeWithinMergedStreams(from: mergedStreams[dictKey]!)
                
            } else { // time range has not been found for merge to happen so we just add this session to the list // Could be a possible merge for a new Time
                mergedStreams[dictKey]!.append(newStream)
            }
          
        } else { // No need to perform Merge cause it is the first new stream for that date!
            mergedStreams[dictKey] = [newStream] // add
        }
    }
}
