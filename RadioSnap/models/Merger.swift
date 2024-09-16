//
//  Merger.swift
//  RadioSnap
//
//  Created by Khondwani Sikasote on 2024/09/16.
//

import Foundation
class Merger {
    var index:Int
    var startTimeMerge:Bool
    var endTimeMerge:Bool
    
    init(streamSession index: Int, startTimeMerge: Bool, endTimeMerge: Bool) {
        self.startTimeMerge = startTimeMerge
        self.endTimeMerge = endTimeMerge
        self.index = index
    }
}
