//
//  Streams.swift
//  RadioSnap
//
//  Created by Khondwani Sikasote on 2024/09/17.
//

import Foundation

class Streams: ObservableObject {
    @Published var streams: [String:[StreamSession]] // if anything changes in it an update occors
    @Published var mergedStreams: [String:[StreamSession]] // only for merges that is what this will keep
    init(streams: [String : [StreamSession]] = [:], mergedStreams: [String:[StreamSession]] = [:]) {
        self.streams = streams
        self.mergedStreams = mergedStreams
    }
    
    func addNewStreamSession(key dictKey: String, value newStream: StreamSession) {
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

        let possibleMergeResult = RadioStreamingFunctions.compareDatesToSeeIfMergeIsReuired(newStartStreamSession: newStream.startDateTime, newEndStreamSession: newStream.endDateTime, existingStreamSessions: mergedStreams[dictKey]!)
            if possibleMergeResult.index != -1 { // we know a time range has been found for merge so we merge
                let oldStream = mergedStreams[dictKey]![possibleMergeResult.index]
                let newMergedStream = RadioStreamingFunctions.performMerge(from: newStream.startDateTime, and: newStream.endDateTime, with: oldStream, decision: possibleMergeResult)
                // replace the oldStream with the newMerged Stream
                mergedStreams[dictKey]![possibleMergeResult.index] = newMergedStream
                
            } else { // time range has not been found for merge to happen so we just add this session to the list // Could be a possible merge for a new Time
                mergedStreams[dictKey]!.append(newStream)
            }
          
        } else { // No need to perform Merge cause it is the first new stream for that date!
            mergedStreams[dictKey] = [newStream] // add
        }
    }
}
