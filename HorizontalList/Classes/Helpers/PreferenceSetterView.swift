//
//  PreferenceSetterView.swift
//  HorizontalList
//
//  Created by Denis Shalagin on 09.06.2020.
//  Copyright © 2020 Distillery. All rights reserved.
//

import SwiftUI

struct ViewRectPreferenceData: Equatable {
    let index: Int
    let rect: CGRect
}

struct ViewRectPreferenceKey: PreferenceKey {
    typealias Value = [ViewRectPreferenceData]

    static var defaultValue: [ViewRectPreferenceData] = []

    static func reduce(value: inout [ViewRectPreferenceData], nextValue: () -> [ViewRectPreferenceData]) {
        value.append(contentsOf: nextValue())
    }
}

struct PreferenceSetterView: View {
    let index: Int
    let coordinateSpaceName: String

    var body: some View {
        GeometryReader { geometry in
            Rectangle()
                .fill(Color.clear)
                .preference(key: ViewRectPreferenceKey.self,
                            value: [ViewRectPreferenceData(index: self.index, rect: geometry.frame(in: .named(self.coordinateSpaceName)))])
        }
    }
}
