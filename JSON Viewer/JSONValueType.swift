//
//  JSONValueType.swift
//  JSON Viewer
//
//  Created by Aditya Dhar on 6/1/23.
//

import SwiftUI
import Foundation

enum JSONValueType {
    case string
    case number
    case bool
    case object
    case array
    case null

    var iconName: String {
        switch self {
        case .string:
            return "text.quote"
        case .number:
            return "number"
        case .bool:
            return "checkmark.circle"
        case .object:
            return "bag"
        case .array:
            return "list.number"
        case .null:
            return "xmark.circle"
        }
    }
    var color: Color {
        switch self {
        case .string:
            return .blue
        case .number:
            return .green
        case .bool:
            return .blue
        case .object:
            return .gray
        case .array:
            return .gray
        case .null:
            return .blue
        }
    }
    var bold: Bool {
        switch self {
        case .bool, .null:
            return true
        default:
            return false
        }
    }
}
