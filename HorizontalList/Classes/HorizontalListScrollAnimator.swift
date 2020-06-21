//
//  HorizontalListScrollAnimator.swift
//  HorizontalList
//
//  Created by Denis Shalagin on 09.06.2020.
//  Copyright © 2020 Distillery. All rights reserved.
//

import SwiftUI

class HorizontalListScrollAnimator {
    var isAnimationFinished: Bool = true

    private var startPosition: CGFloat = 0
    private var endPosition: CGFloat = 0
    private var scrollDuration: Double = 0
    private var startTime: TimeInterval = 0

    func start(from start: CGFloat, to end: CGFloat, duration: Double = 1.0) {
        startPosition = start
        endPosition = end
        scrollDuration = duration
        isAnimationFinished = false
        startTime = CACurrentMediaTime()
    }

    func stop() {
        startPosition = 0
        endPosition = 0
        scrollDuration = 0
        isAnimationFinished = true
        startTime = 0
    }

    func nextStep() -> CGFloat {
        let currentTime = CACurrentMediaTime()

        let time = TimeInterval(min(1, (currentTime - startTime) / scrollDuration))
        
        if time >= 1 {
            isAnimationFinished = true
            return endPosition
        }

        let delta = easeOut(time: time)
        let scrollOffset = startPosition + (endPosition - startPosition) * CGFloat(delta)

        return scrollOffset
    }

    private func easeOut(time: TimeInterval) -> TimeInterval {
        return 1 - pow((1 - time), 4)
    }
}
