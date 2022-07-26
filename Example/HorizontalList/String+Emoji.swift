//
//  String+Emoji.swift
//  HorizontalList_Example
//
//  Created by Denis Shalagin on 20.06.2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

extension String {
    static func randomEmoji() -> String {
        let ascii = Int.random(in: 0x1F601...0x1F64F)
        let emoji = UnicodeScalar(ascii)?.description
        
        return emoji!
    }
    
    static func emoji(index: Int) -> String {
        let ascii = 0x1F601 + index
        let emoji = UnicodeScalar(ascii)?.description
        
        return emoji!
    }
}
