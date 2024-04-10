//
//  BenchTimer.swift
//  GalleryAppForInnowise
//
//  Created by Artem Kutasevich on 2.04.24.
//

import Foundation

final class BenchTimer {

    let startTime: CFAbsoluteTime
    var endTime: CFAbsoluteTime?

    init() {
        startTime = CFAbsoluteTimeGetCurrent()
    }

    func stop() -> CFAbsoluteTime {
        endTime = CFAbsoluteTimeGetCurrent()
        return duration ?? 0.0
    }

    var duration: CFAbsoluteTime? {
        if let endTime = endTime {
            return endTime - startTime
        } else {
            return nil
        }
    }
}
