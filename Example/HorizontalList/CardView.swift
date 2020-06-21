//
//  ContentItemView.swift
//  HorizontalList
//
//  Created by Denis Shalagin on 06.06.2020.
//  Copyright © 2020 Distillery. All rights reserved.
//

import SwiftUI

public struct CardView : View {
    
    // MARK: - Properties
    
    var index: Int
    var title: String
    
    // MARK: - View
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                RadialGradient(gradient: Gradient(colors: [.white, .blue]),
                               center: .center,
                               startRadius: 2,
                               endRadius: geometry.frame(in: .global).width)
                VStack {
                    HStack {
                        Spacer()
                        Text("\(self.index)")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                            .padding(10)
                    }
                    Spacer()
                }
                Circle()
                    .fill(Color.white)
                    .frame(width: 88, height: 88)
                Text(self.title)
                    .font(.system(size: 48))
            }.cornerRadius(15)
        }
    }
}

