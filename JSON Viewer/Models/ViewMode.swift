//
//  ViewMode.swift
//  JSON Viewer
//
//  Created by Aditya Dhar on 6/10/23.
//

import Foundation

enum ViewMode {
    case spacious
    case compact
    
    var description: String {
        switch self {
        case .spacious:
            return "Spacious"
        case .compact:
            return "Compact"
        }
    }
}
