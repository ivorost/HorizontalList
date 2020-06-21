//
//  HorizontalListModel.swift
//  HorizontalList
//
//  Created by Denis Shalagin on 09.06.2020.
//  Copyright © 2020 Distillery. All rights reserved.
//

import SwiftUI

class HorizontalListModel<Content> where Content : View {
    var cachedContent: [Int: Content] = [:]

    init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(clearCacheData),
                                               name: UIApplication.didReceiveMemoryWarningNotification,
                                               object: nil)
    }

    @objc func clearCacheData() {
        cachedContent.removeAll()
    }
}
