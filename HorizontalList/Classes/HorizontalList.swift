//
//  HorizontalList.swift
//  HorizontalList
//
//  Created by Denis Shalagin on 02.06.2020.
//  Copyright © 2020 Distillery. All rights reserved.
//

import SwiftUI

fileprivate func max(_ p1: CGPoint, _ p2: CGPoint) -> CGPoint {
    return CGPoint(x: max(p1.x, p2.x), y: max(p1.y, p2.y))
}

public struct HList<Content, Data> : View where Content : View, Data: RandomAccessCollection {
    
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
    
    // MARK: - State
    
    @State private var visibleIndices: ClosedRange<Int> = 0...0
    @State private var rects: [Int: CGRect] = [:]
    @State private var scrollOffset = CGPoint.zero
    @State private var visibleItemsOffset = CGPoint.zero
    @State private var contentSize = CGSize.zero
    @State private var geometry: GeometryProxy?

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
        GeometryReader { scrollViewGeometry in
            ObservableScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    Spacer()
                        .frame(width: visibleItemsOffset.x)

                    HStack(spacing: 0) {
                        if !self.data.isEmpty {
                            ForEach(self.visibleIndices, id: \.self) { index in
                                self.makeView(atIndex: index)
                            }
                            .onPreferenceChange(ViewRectPreferenceKey.self) { preferences in
                                self.geometry = scrollViewGeometry
                                
                                // Update subviews rects
                                
                                for preference in preferences {
                                    var rect = preference.rect
                                    
                                    if let prevRect = self.rects[preference.index - 1] {
                                        rect = CGRect(x: prevRect.maxX,
                                                      y: rect.minY,
                                                      width: rect.width,
                                                      height: rect.height)
                                    }
                                    
                                    rect.origin = max(rect.origin, .zero)
                                    
                                    self.rects[preference.index] = rect
                                }
                                                                
                                updateContentSize()
                                updateVisibleIndices()
                            }
                            .rotation3DEffectForRightToLeftLayoutDirection()
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .coordinateSpace(name: Constants.coordinateSpaceName)
                }
                .frame(width: contentSize.width)
            }
            .onScroll { offset in
                self.scrollOffset = offset
                self.geometry = scrollViewGeometry
                updateVisibleIndices()
            }
            .flipsForRightToLeftLayoutDirection(true)
        }
    }
    
    // MARK: - Private Helpers
    
    private func makeView(atIndex index: Int) -> some View {
        let item = data[index]
        var content = model.cachedContent[index]

        if content == nil {
            content = itemContent(item)
            model.cachedContent[index] = content
        }
        
        return content
            .background(PreferenceSetterView(index: index, coordinateSpaceName: Constants.coordinateSpaceName))
    }

    private func updateVisibleIndices() {
        guard let geometry = self.geometry else { return }
        
        // Get horizontal list bounds
        let bounds = geometry.frame(in: .named(Constants.coordinateSpaceName))
        
        // Calculate visible frame with offset
        let visibleFrame = CGRect(x: scrollOffset.x, y: 0, width: bounds.width, height: bounds.height)
        
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
        
        // update offset
        
        if let firstIndex = visibleIndices.first, let firstRect = rects[firstIndex] {
            visibleItemsOffset = firstRect.origin
        }
    }
    
    private func updateContentSize() {
        var contentSize = CGSize.zero
        
        contentSize = self.rects.reduce(contentSize) {
            var result = $0
            
            if $1.value.maxX > result.width {
                result.width = $1.value.maxX
            }

            if $1.value.maxY > result.height {
                result.height = $1.value.maxY
            }
            
            return result
        }
        
        self.contentSize = contentSize
    }
}
