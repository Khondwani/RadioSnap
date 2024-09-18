//
//  StreamStatisticsSwiftViewUI.swift
//  RadioSnap
//
//  Created by Khondwani Sikasote on 2024/09/17.
//

import SwiftUI
import Charts

struct StreamStatisticsSwiftViewUI: View {
    @ObservedObject var data: Streams = Streams.sharedInstance
    
//    @ObservedObject var mergedStreamData: MergedStreams
//    
    var body: some View {
        
        VStack( alignment: .center, spacing:16, content: {
            Text("Streams") // Chart title
                           .font(.title)
                           .bold()
                           .padding()
            
            if data.streams.isEmpty {
                Text("You currently have no sessions. Go and add one!! 🎶").padding(EdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 0))
            } else {
                Chart(data.streams["18/09/24"] ?? []) { stream in
                    RuleMark(
                        xStart: .value("Start Date", stream.startDateTime),
                        xEnd: .value("End Date", stream.endDateTime),
                        y: .value("Stream Session", stream.streamName)
                        
                    ).annotation(position: .top, content: {
                        Text("Session:  \(RadioStreamingFunctions.convertDateToString(from: stream.startDateTime)) - \(RadioStreamingFunctions.convertDateToString(from: stream.endDateTime))") .font(.caption)
                    }).annotation(position: .bottom, content: {
                        Text("Duration: \(RadioStreamingFunctions.secondsToFormatTimeRange(stream.duration))") .font(.caption)
                    })
                }
            }
            
            Text("Merged Streams") // Chart title
                           .font(.title)
                           .bold()
                           .padding()
            if data.mergedStreams.isEmpty
            {
                Text("You currently have no sessions. Go and add one!! 🎶").padding(EdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 0))
            } else {
                Chart(data.mergedStreams["18/09/24"] ?? []) { mergeStream in
                 RuleMark(
                     xStart: .value("Start Date", mergeStream.startDateTime),
                     xEnd: .value("End Date",mergeStream.endDateTime),
                     
                     y: .value("Stream Session", mergeStream.streamName)
                     
                 ).annotation(position: .top, content: {
                     Text("Session:  \(RadioStreamingFunctions.convertDateToString(from: mergeStream.startDateTime)) - \(RadioStreamingFunctions.convertDateToString(from: mergeStream.endDateTime))") .font(.caption)
                 }).annotation(position: .bottom, content: {
                     Text("Duration: \(RadioStreamingFunctions.secondsToFormatTimeRange(mergeStream.duration)), Merge Count: \(mergeStream.mergeCount)") .font(.caption)
                 })
             }
            }
            
               
        }).padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
    }
}

#Preview {
    StreamStatisticsSwiftViewUI()
}
