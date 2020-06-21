//
//  HorizontalList.swift
//  HorizontalList
//
//  Created by Denis Shalagin on 02.06.2020.
//  Copyright © 2020 Distillery. All rights reserved.
//

import SwiftUI

public struct HorizontalList<Content, Data> : View where Content : View, Data: RandomAccessCollection {
    
    // MARK: - Constants
    
    struct Constants {
        static var coordinateSpaceName: String {
            return "HorizontalListCoordinateSpaceName"
        }
    }
    
    // MARK: - Properties
    
    private let data: [Data.Element]
    private let itemContent: (Data.Element) -> Content
    
    private let model = HorizontalListModel<Content>()
    private var scrollAnimator = HorizontalListScrollAnimator()
    
    var contentOffset: CGFloat {
        return safeOffset(x: offset + dragOffset)
    }
    
    // MARK: - State
    
    @State private var visibleIndices: ClosedRange<Int> = 0...0
    @State private var rects: [Int: CGRect] = [:]
    @State private var offset: CGFloat = 0
    @State private var dragOffset: CGFloat = 0
    @State private var maxOffset: CGFloat?
    @State private var animationTimer = Timer.publish (every: 1/60, on: .current, in: .common).autoconnect()
    
    // MARK: - Initialization
    
    public init(_ data: Data, @ViewBuilder itemContent: @escaping (Data.Element) -> Content) {
        self.itemContent = itemContent
        
        if let range = data as? Range<Int> {
            self.data = Array(range.lowerBound..<range.upperBound) as! [Data.Element]
        } else if let range = data as? ClosedRange<Int> {
            self.data = Array(range.lowerBound..<range.upperBound) as! [Data.Element]
        } else if let array = data as? [Data.Element] {
            self.data = array
        } else {
            fatalError("Unsupported data type.")
        }
    }
    
    // MARK: - View
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                if !self.data.isEmpty {
                    ForEach(self.visibleIndices, id: \.self) { index in
                        self.makeView(atIndex: index)
                    }
                }
            }
            .gesture(
                TapGesture()
                    .onEnded({ _ in
                        // Stop scroll animation on tap
                        self.scrollAnimator.stop()
                        self.animationTimer.upstream.connect().cancel()
                    }))
                .gesture(
                    DragGesture()
                        .onChanged({ value in
                            // Scroll by dragging
                            self.dragOffset = -value.translation.width
                            self.updateVisibleIndices(geometry: geometry)
                        })
                        .onEnded({ value in
                            let predictedWidth = value.predictedEndTranslation.width * 0.75
                            if abs(predictedWidth) - abs(self.dragOffset) > geometry.size.width / 2 {
                                // Scroll with animation to predicted offset
                                self.dragOffset = 0
                                
                                self.scrollAnimator.start(from: self.offset, to: (self.offset - predictedWidth), duration: 2)
                                self.animationTimer = Timer.publish (every: 1/60, on: .current, in:.common).autoconnect()
                            } else {
                                // Save dragging offset
                                self.offset = self.safeOffset(x: self.offset + self.dragOffset)
                                self.dragOffset = 0
                                
                                self.updateVisibleIndices(geometry: geometry)
                            }
                        }))
                .onPreferenceChange(ViewRectPreferenceKey.self) { preferences in
                    // Update subviews rects
                    for preference in preferences {
                        var rect = preference.rect
                        if let prevRect = self.rects[preference.index - 1] {
                            rect = CGRect(x: prevRect.maxX, y: rect.minY, width: rect.width, height: rect.height)
                        }
                        
                        self.rects[preference.index] = rect
                        
                        // Update max valid offset if needed
                        if self.maxOffset == nil, let lastRect = self.rects[self.data.count - 1] {
                            self.maxOffset = max(0, lastRect.maxX - geometry.frame(in: .global).width)
                        }
                    }
                    
                    self.updateVisibleIndices(geometry: geometry)
            }
            .onReceive(self.animationTimer) { _ in
                if self.scrollAnimator.isAnimationFinished {
                    // We don't need it when we start off
                    self.animationTimer.upstream.connect().cancel()
                    return
                }
                
                self.offset = self.scrollAnimator.nextStep()
                
                // Check if out of bounds
                let safeOffset = self.safeOffset(x: self.offset)
                if self.offset != safeOffset {
                    self.offset = safeOffset
                    self.dragOffset = 0
                    self.animationTimer.upstream.connect().cancel()
                }
                
                self.updateVisibleIndices(geometry: geometry)
            }
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            .coordinateSpace(name: Constants.coordinateSpaceName)
        }
    }
    
    // MARK: - Private Helpers
    
    private func makeView(atIndex index: Int) -> some View {
        let item = data[index]
        let rect = rects[index] ?? .zero
        
        var content = model.cachedContent[index]
        if content == nil {
            content = itemContent(item)
            model.cachedContent[index] = content
        }
        
        return content
            .offset(x: rect.minX - contentOffset)
            .background(PreferenceSetterView(index: index, coordinateSpaceName: Constants.coordinateSpaceName))
    }
    
    private func updateVisibleIndices(geometry: GeometryProxy) {
        // Get horizontal list bounds
        let bounds = geometry.frame(in: .named(Constants.coordinateSpaceName))
        
        // Calculate visible frame with offset
        let visibleFrame = CGRect(x: contentOffset, y: 0, width: bounds.width, height: bounds.height)
        
        // Find indices which intersect visible frame
        var frameIndices: [Int] = []
        for (index, rect) in rects {
            if rect.intersects(visibleFrame) {
                frameIndices.append(index)
            }
        }
        frameIndices.sort()
        
        // Safe first and last index initialization
        let firstIndex = frameIndices.first ?? 0
        var lastIndex = frameIndices.last ?? 0
        
        // If there is a free space add one more index if exist
        if rects[lastIndex]?.maxX ?? 0 < visibleFrame.maxX, lastIndex < self.data.count - 1 {
            lastIndex += 1
        }
        
        // Update model with new visible indices
        visibleIndices = firstIndex...lastIndex
    }
    
    private func safeOffset(x: CGFloat) -> CGFloat {
        return x.clamped(to: 0...(maxOffset ?? CGFloat.greatestFiniteMagnitude))
    }
    
}
