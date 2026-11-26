//
//  Item.swift
//  NewsTask
//
//  Created by vvelon on 26.11.2026.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
