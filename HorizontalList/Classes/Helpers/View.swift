//
//  View.swift
//  HorizontalList
//
//  Created by Ivan Kh on 26.07.2022.
//

import SwiftUI

extension View {
    public func rotation3DEffectForRightToLeftLayoutDirection(for direction: LayoutDirection) -> some View {
        if direction == .rightToLeft {
            return self.rotation3DEffect(Angle(degrees: 180),
                                         axis: (x: CGFloat(0),
                                                y: CGFloat(10),
                                                z: CGFloat(0)))
        }
        else {
            return self.rotation3DEffect(Angle(degrees: 180),
                                         axis: (x: CGFloat(0),
                                                y: CGFloat(0),
                                                z: CGFloat(0)))
        }
    }
}
