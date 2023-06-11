//
//  JSONValueType.swift
//  JSON Viewer
//
//  Created by Aditya Dhar on 6/1/23.
//

import SwiftUI
import Foundation

enum JSONValueType: Codable {
    case string
    case number
    case bool
    case object
    case array
    case null
    
    // Since this is an enum, we need to provide custom encoding/decoding
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let typeInt = try container.decode(Int.self)
        switch typeInt {
        case 0:
            self = .string
        case 1:
            self = .number
        case 2:
            self = .bool
        case 3:
            self = .object
        case 4:
            self = .array
        case 5:
            self = .null
        default:
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid JSONValueType")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let typeInt: Int
        switch self {
        case .string:
            typeInt = 0
        case .number:
            typeInt = 1
        case .bool:
            typeInt = 2
        case .object:
            typeInt = 3
        case .array:
            typeInt = 4
        case .null:
            typeInt = 5
        }
        try container.encode(typeInt)
    }

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
