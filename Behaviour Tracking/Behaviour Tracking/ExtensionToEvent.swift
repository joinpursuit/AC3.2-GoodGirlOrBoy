//
//  ExtensionToEvent.swift
//  Behaviour Tracking
//
//  Created by Tong Lin on 12/31/16.
//  Copyright © 2016 Tong Lin. All rights reserved.
//

import Foundation

extension Event{
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
    
    private var dateString: String? {
        return timestamp.map { Event.dateFormatter.string(from: $0 as Date) }
    }
    
    var textForCell: String? {
        let text = "\(self.dateString ?? "error") \(self.name ?? "error") \(self.behaviour ?? "error")"
        return self.type ? "\(text) 👍" : "\(text) 👎"
    }
}
