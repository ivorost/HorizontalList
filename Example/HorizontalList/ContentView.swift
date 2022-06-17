//
//  ContentView.swift
//  HorizontalList
//
//  Created by Denis Shalagin on 02.06.2020.
//  Copyright © 2020 Distillery. All rights reserved.
//

import SwiftUI
import HorizontalList

struct ContentView: View {
    
    struct Constants {
        static var itemsCount = 1000
        static var itemSize: CGSize {
            return .init(width: 150, height: 200)
        }
    }
    
    // MARK: - Properties
    
    var items: [String] = []
    
    init() {
        items = generateData()
    }
    
    // MARK: - View
    
    var body: some View {
        HList(0..<items.count) { index in
            self.makeView(index: index)
                .frame(width: Constants.itemSize.width, height: Constants.itemSize.height)
                .padding(10)
        }
    }
    
    // MARK: - View Helpers
    
    private func makeView(index: Int) -> some View {
        return CardView(index: index, title: items[index])
    }
    
    private func generateData() -> [String] {
        var data: [String] = []
        for _ in 0..<Constants.itemsCount {
            data.append(String.randomEmoji())
        }
        
        return data
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
