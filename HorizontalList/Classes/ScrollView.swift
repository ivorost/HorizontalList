//
//  ScrollView.swift
//  HorizontalList
//
//  Created by Ivan Kh on 09.06.2022.
//

import SwiftUI


// Simple preference that observes a CGFloat.
struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue = CGPoint.zero
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
        value.x += nextValue().x
        value.y += nextValue().y
    }
}


// A ScrollView wrapper that tracks scroll offset changes.
public struct ObservableScrollView<Content>: View where Content : View {
    @Namespace var scrollSpace
    
    let content: () -> Content
    var axes: Axis.Set
    var showsIndicators: Bool

    public init(_ axes: Axis.Set = .vertical,
                showsIndicators: Bool = true,
                @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.axes = axes
        self.showsIndicators = showsIndicators
    }
    
    public var body: some View {
        ScrollView(self.axes, showsIndicators: self.showsIndicators) {
            content()
                .background(GeometryReader { geometry in
                    let offsetX = -geometry.frame(in: .named(scrollSpace)).minX
                    let offsetY = -geometry.frame(in: .named(scrollSpace)).minY

                    Color.clear
                        .preference(key: ScrollOffsetPreferenceKey.self, value: CGPoint(x: offsetX, y: offsetY))
                })
        }
        .edgesIgnoringSafeArea(.vertical)
        .coordinateSpace(name: scrollSpace)
    }
}


extension ObservableScrollView {
    public func onScroll(_ onScroll: @escaping (CGPoint) -> ()) -> some View {
        self.onPreferenceChange(ScrollOffsetPreferenceKey.self, perform: onScroll)
    }
}

